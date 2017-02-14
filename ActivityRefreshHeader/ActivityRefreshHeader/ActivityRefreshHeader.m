//
//  ActivityRefreshHeader.m
//  ActivityRefreshHeader
//
//  Created by xiabob on 17/2/14.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "ActivityRefreshHeader.h"

@interface ActivityRefreshHeader()

@property (nonatomic, weak, readwrite) UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation ActivityRefreshHeader

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        self.state = ACRefreshStateIdle;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    _hintLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _hintLabel.textColor = [UIColor orangeColor];
    _hintLabel.text = @"下拉刷新";
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hintLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self placeSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
//        self.frame = CGRectMake(0, 0, newSuperview.frame.size.width, 0);
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        // 添加监听
        [self addObservers];
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        
    }
    
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    if (self.state == ACRefreshStateRefreshing) {
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.frame.size.height;
    CGFloat pulling2PromotionIdleOffsetY = normal2pullingOffsetY - 40;
    CGFloat idle2PromotionPullingOffsetY = pulling2PromotionIdleOffsetY - 30;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        if (offsetY < idle2PromotionPullingOffsetY) {
            // 转为即将刷新状态
            self.state = ACRefreshStatePromotionPulling;
        } else if (offsetY < pulling2PromotionIdleOffsetY) {
            self.state = ACRefreshStatePromotionIdle;
        } else if (offsetY < normal2pullingOffsetY) {
            self.state = ACRefreshStatePulling;
        } else {
            self.state = ACRefreshStateIdle;
        }
    } else if (self.state == ACRefreshStatePulling) {
        [self beginRefreshing];
    }
}

- (void)setState:(ACRefreshState)state {
    ACRefreshState oldState = self.state;
    if (oldState == state) {return;}
    
    _state = state;
    if (state == ACRefreshStateIdle) {
        self.hintLabel.text = @"下拉刷新";
        if (oldState != ACRefreshStateRefreshing) {return;}
        
        // 恢复inset和offset
        [UIView animateWithDuration:0.25 animations:^{
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.top -= self.bounds.size.height;
            self.scrollView.contentInset = insets;
        }];
    } else if (state == ACRefreshStatePulling) {
        self.hintLabel.text = @"松开开始刷新";
    } else if (state == ACRefreshStatePromotionIdle) {
        self.hintLabel.text = @"继续下拉有惊喜";
    } else if (state == ACRefreshStatePromotionPulling) {
        self.hintLabel.text = @"松开得惊喜";
    } else if (state == ACRefreshStateRefreshing) {
        self.hintLabel.text = @"正在刷新……";
        
        [UIView animateWithDuration:0.25 animations:^{
            // 增加滚动区域
            CGFloat top = self.scrollViewOriginalInset.top + self.bounds.size.height;
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.top = top;
            self.scrollView.contentInset = insets;
            
            // 设置滚动位置
            self.scrollView.contentOffset = CGPointMake(0, -top);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)beginRefreshing {
    self.state = ACRefreshStateRefreshing;
    
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:3];
}

- (void)endRefreshing {
    self.state = ACRefreshStateIdle;
}

@end

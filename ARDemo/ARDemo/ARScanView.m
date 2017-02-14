//
//  ARScanView.m
//  ARDemo
//
//  Created by xiabob on 17/1/6.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "ARScanView.h"

@interface ARScanView()

@property (nonatomic, strong) UIImageView *scanNetImageView;
@property (nonatomic, strong) UIView *scanWindow;

@end

@implementation ARScanView

- (UIImageView *)scanNetImageView {
    if (!_scanNetImageView) {
        _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
        _scanNetImageView.contentMode = UIViewContentModeScaleAspectFill;
        _scanNetImageView.clipsToBounds = YES;
    }
    
    return _scanNetImageView;
}

- (UIView *)scanWindow {
    if (!_scanWindow) {
        _scanWindow = [[UIView alloc] init];
        _scanWindow.backgroundColor = [UIColor clearColor];
        _scanWindow.layer.borderColor = [UIColor redColor].CGColor;
        _scanWindow.layer.borderWidth = 2;
        _scanWindow.clipsToBounds = YES;
    }
    
    return _scanWindow;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGFloat size = MIN(width, height) * 0.6;
    self.scanWindow.frame = CGRectMake(0, 0, size, size);
    self.scanWindow.center = self.center;
    
    [self.scanWindow addSubview:self.scanNetImageView];
    [self addSubview:self.scanWindow];
}

- (void)startAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    
    CGFloat width = self.scanWindow.bounds.size.width;
    self.scanNetImageView.frame = CGRectMake(0, -width, width, width);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(self.scanNetImageView.bounds.size.height);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
}

- (void)stopAnimation {
    // 1. 将动画的时间偏移量作为暂停时的时间点
    CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
    // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
    CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
    
    // 3. 要把偏移时间清零
    [_scanNetImageView.layer setTimeOffset:0.0];
    // 4. 设置图层的开始动画时间
    [_scanNetImageView.layer setBeginTime:beginTime];
    
    [_scanNetImageView.layer setSpeed:1.0];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

@end

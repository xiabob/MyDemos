//
//  AREggLoadingView.m
//  ARDemo
//
//  Created by xiabob on 17/1/5.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "AREggLoadingView.h"
#import "YYWebImage.h"


@interface AREggLoadingView()

@property (nonatomic, strong) YYAnimatedImageView *contentImageView;

@end

@implementation AREggLoadingView

- (YYAnimatedImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[YYAnimatedImageView alloc] init];
        NSData *imageData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]
                                                           URLForResource:@"egg" withExtension:@"gif"]];
        _contentImageView.image = [YYImage imageWithData:imageData];
    }
    
    return _contentImageView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    
    return self;
}

- (void)configViews {
    self.contentImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);;
    [self addSubview:self.contentImageView];
    
    self.hidden = YES;
    [self.contentImageView stopAnimating];
}

- (void)showLoadingViewWithDuratin:(NSTimeInterval)time andCompleteBlock:(ARLoadingBlock)block {
    self.hidden = NO;
    [self.contentImageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(time * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self.hidden = YES;
                       [self removeFromSuperview];
                       if (block) {
                           block();
                       }
    });
}

@end

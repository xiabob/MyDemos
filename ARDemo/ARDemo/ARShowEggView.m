//
//  ARShowEggView.m
//  ARDemo
//
//  Created by xiabob on 17/1/6.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "ARShowEggView.h"

@interface ARShowEggView()

@property (nonatomic, strong) UIImageView *egg;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origineCenter;

@end

@implementation ARShowEggView

- (UIImageView *)egg {
    if (!_egg) {
        _egg = [[UIImageView alloc] init];
        _egg.contentMode = UIViewContentModeScaleAspectFit;
        _egg.image = [UIImage imageNamed:@"egg"];
        [_egg sizeToFit];
    }
    
    return _egg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.origineCenter = self.center;
    self.width = self.frame.size.width;
    self.height = self.frame.size.height;
    
    self.egg.center = self.center;
    [self addSubview:self.egg];
}

- (void)showEggWithDuratin:(NSTimeInterval)time andCompleteBlock:(ARCompleteBlock)block {
    self.hidden = NO;
    
    [self doAnimationing:time];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(time * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self.hidden = YES;
                       [self removeFromSuperview];
                       self.egg.transform = CGAffineTransformIdentity;
                       if (block) {
                           block();
                       }
                   });
}

- (void)doAnimationing:(NSTimeInterval)time {
    //idel state
    self.center = CGPointMake(self.origineCenter.x, 0);
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    
    [UIView animateWithDuration:time/2
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.center = self.origineCenter;
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:^(BOOL finished) {
//                         [self shakeAnimation];
                     }
     ];
}

- (void)shakeAnimation {
    
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: -M_PI_4];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_4];
    rotationAnimation.duration = 0.2;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.cumulative = NO; //kCAMediaTimingFunctionEaseIn
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end

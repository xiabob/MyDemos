//
//  ARPopView.m
//  ARToolKit5iOS
//
//  Created by xiabob on 17/1/4.
//
//

#import "ARPopView.h"

@interface ARPopView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) CGPoint origineCenter;
@property (nonatomic, assign) CGSize origineSize;

@end

@implementation ARPopView


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_leftButton setTitle:@"给好友送“吉”" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_rightButton setTitle:@"继续孵蛋" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configViews];
    }
    
    return self;
}

- (void)configViews {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.origineCenter = self.center;
    self.origineSize = self.bounds.size;
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    rect.size = CGSizeMake(rect.size.width, rect.size.height-40);
    self.imageView.frame = rect;
    
    CGFloat width = (rect.size.width - 12*2 - 30)/2;
    self.leftButton.frame = CGRectMake(12, CGRectGetMaxY(rect) + 10, width, 20);
    self.rightButton.frame = CGRectMake(CGRectGetMaxX(self.leftButton.frame)+30, self.leftButton.frame.origin.y, width, 20);
    
    [self addSubview:self.imageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    
    self.hidden = YES;
}

- (void)show {
    self.hidden = NO;

    self.center = CGPointMake(self.origineCenter.x, -self.origineCenter.y);
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:25
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.center = self.origineCenter;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    [UIView animateWithDuration:0.15
                          delay:0.25
         usingSpringWithDamping:0.4
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

- (void)hide {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.center = CGPointMake(self.origineCenter.x, -self.origineCenter.y);
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self removeFromSuperview];
                     }
     ];
}

- (void)leftButtonClick {
    if ([self.delegate respondsToSelector:@selector(onLeftButtonClicked:)]) {
        [self.delegate onLeftButtonClicked:self];
    }
}

- (void)rightButtonClick {
    if ([self.delegate respondsToSelector:@selector(onRightButtonClicked:)]) {
        [self.delegate onRightButtonClicked:self];
    }
}

@end

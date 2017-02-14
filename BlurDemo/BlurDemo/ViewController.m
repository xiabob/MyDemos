//
//  ViewController.m
//  BlurDemo
//
//  Created by xiabob on 17/2/6.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "ViewController.h"
#import "FXBlurView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) FXBlurView *fxBlurView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger num;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.fxBlurView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}


- (UIView *)backgroundView {
    if (!_backgroundView) {
        CGRect frame = self.view.bounds;
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        
        _backgroundView.layer.contents = (__bridge id _Nullable)(self.imagesArray[self.num].CGImage);
        _backgroundView.layer.contentsGravity = kCAGravityResizeAspect;
        _backgroundView.layer.masksToBounds = YES;
    }
    
    return _backgroundView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [_containerView addSubview:view];
    }
    
    return _containerView;
}

- (UIVisualEffectView *)blurView { //所有视图
    if (!_blurView) {
        CGRect frame = CGRectMake(0, 0, 200, 480);
        _blurView = [[UIVisualEffectView alloc] initWithFrame:frame];
        _blurView.center = self.view.center;
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurView.effect = effect;
        
        UILabel *label = [UILabel new];
        label.text = @"测试文字……";
        [label sizeToFit];
        [_blurView addSubview:label];
        label.center = _blurView.center;
    }
    
    return _blurView;
}

- (FXBlurView *)fxBlurView { //所有视图，可以指定underlyingView，默认是superview，你需要指定合适的underlyingView才能有效果
    if (!_fxBlurView) {
        CGRect frame = CGRectMake(0, 0, 200, 480);
        _fxBlurView = [[FXBlurView alloc] initWithFrame:frame];
        _fxBlurView.underlyingView = self.view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:_fxBlurView.bounds];
        label.text = @"模糊效果怎么样？";
        label.textAlignment = NSTextAlignmentCenter;
        [_fxBlurView addSubview:label];
    }
    
    return _fxBlurView;
}

- (NSMutableArray<UIImage *> *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray new];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Koala" ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [_imagesArray addObject:image];
        
        path = [[NSBundle mainBundle] pathForResource:@"Chrysanthemum" ofType:@"jpg"];
        image = [UIImage imageWithContentsOfFile:path];
        [_imagesArray addObject:image];
        
        path = [[NSBundle mainBundle] pathForResource:@"Penguins" ofType:@"jpg"];
        image = [UIImage imageWithContentsOfFile:path];
        [_imagesArray addObject:image];
    }
    
    return _imagesArray;
}

- (void)changeImage {
    self.num += 1;
    self.backgroundView.layer.contents = (__bridge id _Nullable)(self.imagesArray[self.num%self.imagesArray.count].CGImage);
}

@end

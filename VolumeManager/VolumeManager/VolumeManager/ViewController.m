//
//  ViewController.m
//  VolumeManager
//
//  Created by xiabob on 16/11/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "VolumeView.h"


#define kBackgroundColor [UIColor grayColor]

@interface ViewController ()<VolumeViewDelegate>

@property (nonatomic, strong) UISlider *volumeViewSlider;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) VolumeView *systemVolumeView;
@property (nonatomic, strong) VolumeView *mediaVolumeView;

@property (nonatomic, assign) XBVolumeType selectedType;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册监听实体键按下事件
    [self registeNotification];
    [self commonInit];
}

- (void)commonInit {
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.mediaVolumeView];
    [self.view addSubview:self.systemVolumeView];
    
    self.selectedType = XBVolumeTypeSystem;
    [[AVAudioSession sharedInstance] setActive:NO error:NULL];
}

- (void)dealloc{
    [self removeNotification];
}


#pragma mark - getter

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _contentView.backgroundColor = kBackgroundColor;
    }
    
    return _contentView;
}

- (UISlider *)volumeViewSlider {
    if (!_volumeViewSlider) {
        //1. 获得 MPVolumeView 实例，
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 1, 1)];
        volumeView.hidden = NO;
        [self.view addSubview:volumeView]; //添加后不显示“音量”
        
        _volumeViewSlider =  nil;
        //2. 遍历MPVolumeView的subViews得到MPVolumeSlider
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    
    return _volumeViewSlider;
}

- (VolumeView *)systemVolumeView {
    if (!_systemVolumeView) {
        CGRect rect = CGRectMake(8, 64, kXBScreenWidth-16, 120);
        _systemVolumeView = [[VolumeView alloc] initWithFrame:rect];
        _systemVolumeView.delegate = self;
         [[AVAudioSession sharedInstance] setActive:NO error:NULL];
        [_systemVolumeView refreshViewWithType:XBVolumeTypeSystem andValue:self.volumeViewSlider.value];
    }
    
    return _systemVolumeView;
}

- (VolumeView *)mediaVolumeView {
    if (!_mediaVolumeView) {
        CGRect rect = CGRectMake(8,
                                 CGRectGetMaxY(self.systemVolumeView.frame)+8,
                                 kXBScreenWidth-16,
                                 120);
        _mediaVolumeView = [[VolumeView alloc] initWithFrame:rect];
        _mediaVolumeView.delegate = self;
        [[AVAudioSession sharedInstance] setActive:YES error:NULL];
        [_mediaVolumeView refreshViewWithType:XBVolumeTypeMedia andValue:self.volumeViewSlider.value];
    }
    
    return _mediaVolumeView;
}

#pragma mark - notification

- (void)registeNotification{
    //注册监听系统音量变化，记得在适当的地方移除监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    //让 UIApplication 开始响应远程的控制，必须添加，不然没效果
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void) removeNotification{
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)volumeChanged:(NSNotification *)notification{
    //获取到当前音量
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    switch (self.selectedType) {
        case XBVolumeTypeSystem:
            [self.systemVolumeView refreshViewWithType:XBVolumeTypeSystem andValue:volume];
            break;
            
        case XBVolumeTypeMedia:
            [self.mediaVolumeView refreshViewWithType:XBVolumeTypeMedia andValue:volume];
            break;
        default:
            break;
    }
}

#pragma mark - VolumeViewDelegate

- (void)onVolumeSliderChangedWithType:(XBVolumeType)type andValue:(CGFloat)value {
    self.selectedType = type;
    switch (self.selectedType) {
        case XBVolumeTypeSystem:
            [[AVAudioSession sharedInstance] setActive:NO error:NULL];
            [self setRingVolumeLevelTo:value];
            break;
        case XBVolumeTypeMedia:
            [[AVAudioSession sharedInstance] setActive:YES error:NULL];
            //改变媒体音量大小，音量大小从 0.0 - 1.0
            [self.volumeViewSlider setValue:value animated:NO];
            //使UI事件立即发生，
            [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
}

//调用了系统的私有方法
- (void)setRingVolumeLevelTo:(float)newVolumeLevel {
    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];
    
    NSString *soundCategory = @"Ringtone";
    
    NSInvocation *volumeInvocation = [NSInvocation invocationWithMethodSignature:
                                      [avSystemControllerClass instanceMethodSignatureForSelector:
                                       @selector(setVolumeTo:forCategory:)]];
    [volumeInvocation setTarget:avSystemControllerInstance];
    [volumeInvocation setSelector:@selector(setVolumeTo:forCategory:)];
    [volumeInvocation setArgument:&newVolumeLevel atIndex:2];
    [volumeInvocation setArgument:&soundCategory atIndex:3];
    [volumeInvocation invoke];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

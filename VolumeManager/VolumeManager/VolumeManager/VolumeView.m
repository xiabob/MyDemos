//
//  VolumeCell.m
//  VolumeManager
//
//  Created by xiabob on 16/11/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "VolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ASValueTrackingSlider.h"
#import "Masonry.h"
#import "XBCommonDefine.h"


@interface VolumeView()<ASValueTrackingSliderDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ASValueTrackingSlider *displaySlider;

@property (nonatomic, assign) XBVolumeType volumeType;

@end

@implementation VolumeView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        [self addSubview:self.displaySlider];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.displaySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(60);
        make.right.mas_equalTo(-8);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.displaySlider.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _titleLabel;
}

- (ASValueTrackingSlider *)displaySlider {
    if (!_displaySlider) {
        _displaySlider = [[ASValueTrackingSlider alloc] init];
        _displaySlider.minimumValue = 0;
        _displaySlider.maximumValue = 1;
        _displaySlider.delegate = self;
        [_displaySlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _displaySlider;
}

- (void)refreshViewWithType:(XBVolumeType)type andValue:(CGFloat)value {
    self.volumeType = type;
    
    switch (self.volumeType) {
            //系统音量
        case XBVolumeTypeSystem:
            self.titleLabel.text = @"调节系统音量";
            break;
            
        case XBVolumeTypeMedia:
            self.titleLabel.text = @"调节媒体音量";
            break;
    }

    self.displaySlider.value = value;
}


#pragma mark - ASValueTrackingSliderDelegate

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider {
    [self.superview bringSubviewToFront:self];
}

#pragma mark - action

- (void)sliderValueChange:(UISlider *)slider{
    //得到当前用户设置的value
    float value = slider.value;
    if ([self.delegate respondsToSelector:@selector(onVolumeSliderChangedWithType:andValue:)]) {
        [self.delegate onVolumeSliderChangedWithType:self.volumeType andValue:value];
    }
}

@end

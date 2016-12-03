//
//  VolumeCell.h
//  VolumeManager
//
//  Created by xiabob on 16/11/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCommonDefine.h"

@protocol VolumeViewDelegate <NSObject>

- (void)onVolumeSliderChangedWithType:(XBVolumeType)type andValue:(CGFloat)value;

@end

@interface VolumeView : UIView

@property (nonatomic, weak) id<VolumeViewDelegate> delegate;

- (void)refreshViewWithType:(XBVolumeType)type andValue:(CGFloat)value;

@end

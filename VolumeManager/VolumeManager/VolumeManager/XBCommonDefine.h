//
//  XBCommonDefine.h
//  VolumeManager
//
//  Created by xiabob on 16/11/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#ifndef XBCommonDefine_h
#define XBCommonDefine_h

#define kXBScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kXBScreenHeight [[UIScreen mainScreen] bounds].size.height



///音量类型
typedef NS_ENUM(NSInteger, XBVolumeType) {
    XBVolumeTypeSystem = 1, //< 系统音量
    XBVolumeTypeMedia = 2,
};

#endif /* XBCommonDefine_h */

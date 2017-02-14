//
//  ActivityRefreshHeader.h
//  ActivityRefreshHeader
//
//  Created by xiabob on 17/2/14.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ACRefreshState) {
    /** 普通初始状态 */
    ACRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    ACRefreshStatePulling,
    /** 正在刷新中的状态 */
    ACRefreshStateRefreshing,
    /** 展示活动的初始状态 */
    ACRefreshStatePromotionIdle,
    /** 松开就可以展示活动的状态 */
    ACRefreshStatePromotionPulling,
    /** 展示活动的状态 */
    ACRefreshStatePromotionShowing,
};

@interface ActivityRefreshHeader : UIView

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) ACRefreshState state;

@end

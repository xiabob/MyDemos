//
//  AREggLoadingView.h
//  ARDemo
//
//  Created by xiabob on 17/1/5.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ARLoadingBlock)();

@interface AREggLoadingView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showLoadingViewWithDuratin:(NSTimeInterval)time andCompleteBlock:(ARLoadingBlock)block;

@end

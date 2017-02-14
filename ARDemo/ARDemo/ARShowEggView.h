//
//  ARShowEggView.h
//  ARDemo
//
//  Created by xiabob on 17/1/6.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ARCompleteBlock)();

@interface ARShowEggView : UIView


- (void)showEggWithDuratin:(NSTimeInterval)time andCompleteBlock:(ARCompleteBlock)block;

@end

//
//  UIScrollView+RefreshHeader.m
//  ActivityRefreshHeader
//
//  Created by xiabob on 17/2/14.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import "UIScrollView+RefreshHeader.h"
#import "ActivityRefreshHeader.h"
#import <objc/runtime.h>


@implementation UIScrollView (RefreshHeader)

- (ActivityRefreshHeader *)ac_header {
    return objc_getAssociatedObject(self, @selector(ac_header));
}

- (void)setAc_header:(ActivityRefreshHeader *)ac_header {
    if (self.ac_header != ac_header) {
        //remove old, add new
        [self.ac_header removeFromSuperview];
        [self insertSubview:ac_header atIndex:0];
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(ac_header))]; //kvo
        objc_setAssociatedObject(self, @selector(ac_header), ac_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:NSStringFromSelector(@selector(ac_header))];
    }
}


@end

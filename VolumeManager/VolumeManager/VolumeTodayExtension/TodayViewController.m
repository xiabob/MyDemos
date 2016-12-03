//
//  TodayViewController.m
//  VolumeTodayExtension
//
//  Created by xiabob on 16/11/10.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation TodayViewController

//http://stackoverflow.com/questions/26168565/uislider-in-today-view-extension-widget


//另外注意设置today extension 的 development target version，默认是最新的iOS版本（比如iOS 10）

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        //iOS10 之后多了“展开”、“折叠”按钮，当处于折叠态时，高度是固定的(Fixed height)。当处于展开状态时，高度是可变的，使用preferredContentSize可以改变。
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    } else {
        //这个参数用来设置vc的尺寸，width值是系统设置的，无需考虑
        self.preferredContentSize = CGSizeMake(0, 200);
    }
    
    [self.view addGestureRecognizer:self.tapGesture];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(gotoApp)];
    }
    
    return _tapGesture;
}

- (IBAction)buttonClick:(id)sender {
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeExpanded) {
            [self changeViewFrame];
        }
    } else {
        [self changeViewFrame];
    }
    
}

- (void)changeViewFrame {
    if (self.view.frame.size.height == 200) {
        self.preferredContentSize = CGSizeMake(0, 100);
    } else {
        self.preferredContentSize = CGSizeMake(0, 200);
    }
}

- (void)gotoApp {
    [self.extensionContext openURL:[NSURL URLWithString:@"volume://"] completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NCWidgetProviding

//ios 10
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0.0, 200.0);
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

//ios 8 -> ios 10
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    //ios10前后边距是不同的
    return UIEdgeInsetsMake(0, -20, 0, 0);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end

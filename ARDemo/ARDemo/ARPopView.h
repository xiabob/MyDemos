//
//  ARPopView.h
//  ARToolKit5iOS
//
//  Created by xiabob on 17/1/4.
//
//

#import <UIKit/UIKit.h>
@class ARPopView;

@protocol ARPopViewDelegate <NSObject>

- (void)onLeftButtonClicked:(ARPopView *)popView;
- (void)onRightButtonClicked:(ARPopView *)popView;

@end

@interface ARPopView : UIView

@property (nonatomic, weak) id<ARPopViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)hide;

@end

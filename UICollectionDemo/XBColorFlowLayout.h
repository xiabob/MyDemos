//
//  XBColorFlowLayout.h
//  DCGame
//
//  Created by xiabob on 2017/4/27.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *backgroundColor;

@end


@interface XBCollectionReusableView : UICollectionReusableView

@end



@protocol XBColorFlowLayoutDelegate <NSObject>

- (UIColor *)collectionView:(UICollectionView *)collectionView backgroundColorInSection:(NSInteger)section;

@end

@interface XBColorFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<XBColorFlowLayoutDelegate> colorLayoutDelegate;

@end

//
//  XBColorFlowLayout.m
//  DCGame
//
//  Created by xiabob on 2017/4/27.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XBColorFlowLayout.h"


#define kSectionBackgroundColor @"kXBUICollectionViewSectionBackgroundColor"

@implementation XBCollectionViewLayoutAttributes

//必须有,否则applyLayoutAttributes中获取不到颜色
- (id)copyWithZone:(NSZone *)zone {
    XBCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.backgroundColor = [self.backgroundColor copyWithZone:zone];
    return newAttributes;
}

@end

@implementation XBCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    XBCollectionViewLayoutAttributes *attr = (XBCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = attr.backgroundColor;
    
    //改变响应链中的位置，否则DecorationView会遮住cell，无法点击（当前layout被继承时，必须有这一步，正常情况下设置zIndex即可。）
    //当被继承使用时需要这样（XBLeftAlignmentFlowLayout继承了），否则仅仅下面的‘attr.zIndex = -1;’就可以了。
    [self.superview sendSubviewToBack:self];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.superview sendSubviewToBack:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.superview sendSubviewToBack:self];
}

@end


@interface XBColorFlowLayout()

@property (nonatomic, strong) NSMutableArray *decorationViewAttrs;

@end

@implementation XBColorFlowLayout

- (NSMutableArray *)decorationViewAttrs {
    if (nil == _decorationViewAttrs) {
        _decorationViewAttrs = [[NSMutableArray alloc] init];
    }
    
    return _decorationViewAttrs;
}

- (instancetype)init {
    if (self = [super init]) {
        [self registerClass:[XBCollectionReusableView class] forDecorationViewOfKind:kSectionBackgroundColor];
    }
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self configDecorationView];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesToReturn = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSMutableArray *decorationAttributes = [NSMutableArray new];
    for (XBCollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [decorationAttributes addObject:attr];
        }
    }
    
    [attributesToReturn addObjectsFromArray:decorationAttributes];
    
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:kSectionBackgroundColor]) {
        for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
            if (attr.indexPath.section == indexPath.section) {
                return attr;
            }
        }
    }
    
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

- (void)configDecorationView {
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;

    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    [self.decorationViewAttrs removeAllObjects];
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        //不要通过代理方法获得numberOfItems，因为通过代理获得的值可能和实际不符合，可能会发生以下crash：
        //1、Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'no UICollectionViewLayoutAttributes instance for -layoutAttributesForDecorationViewOfKindOfKind: kXBUICollectionViewSectionBackgroundColor at path <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}'
        //2、*** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM objectAtIndex:]: index 8 beyond bounds [0 .. 7]'
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems > 0) {
            UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems-1 inSection:section]];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                sectionInset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            }
            
            CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
            sectionFrame.origin.x -= sectionInset.left;
            sectionFrame.origin.y -= sectionInset.top;
            
            //header
            CGSize headerSize = self.headerReferenceSize;
            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                headerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
            }
            
            //footer
            CGSize footerSize = self.footerReferenceSize;
            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                footerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
            }
            
            if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                sectionFrame.size.width += sectionInset.left + sectionInset.right;
                sectionFrame.size.height = ceil(self.collectionView.frame.size.height);
            } else {
                sectionFrame.size.width = self.collectionView.frame.size.width;
                sectionFrame.size.height += ceil(sectionInset.top + sectionInset.bottom);
            }
            
            XBCollectionViewLayoutAttributes *attr = [XBCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kSectionBackgroundColor withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            if (attr) {
                attr.frame = sectionFrame;
                attr.zIndex = -1;
//                attr.transform3D = CATransform3DMakeTranslation(0, 0, -1);
                attr.backgroundColor = [self.colorLayoutDelegate collectionView:self.collectionView backgroundColorInSection:section];
                [self.decorationViewAttrs addObject:attr];
            }
        }
        
    }

}


@end

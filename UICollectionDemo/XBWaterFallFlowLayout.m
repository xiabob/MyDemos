//
//  XBWaterFallFlowLayout.m
//  DCGame
//
//  Created by xiabob on 2017/4/27.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XBWaterFallFlowLayout.h"

@interface XBWaterFallFlowLayout()

@property (nonatomic, strong) NSMutableArray *columnCounts; ///< 每个section对应的列数
@property (nonatomic, strong) NSMutableArray *itemWidths; ///< 每个section对应的cell的宽度
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSMutableArray *cellLayoutAttributesArray;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *supplementaryViewLayoutAttributesArray;

@end

@implementation XBWaterFallFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.columnCounts = [NSMutableArray new];
        self.itemWidths = [NSMutableArray new];
        self.columnHeights = [NSMutableArray new];
        self.cellLayoutAttributesArray = [NSMutableArray new];
        self.supplementaryViewLayoutAttributesArray = [NSMutableArray new];
    }
    
    return self;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    
    self.contentHeight = 0;
    [self.columnCounts removeAllObjects];
    [self.itemWidths removeAllObjects];
    [self.columnHeights removeAllObjects];
    [self.cellLayoutAttributesArray removeAllObjects];
    [self.supplementaryViewLayoutAttributesArray removeAllObjects];
    
    NSUInteger section = 1;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        section = [dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
    for (NSUInteger i=0; i<section; i++) {
        NSUInteger numberOfItems = 1;
        if ([dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            numberOfItems = [dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        }
        
        UIEdgeInsets insets = self.sectionInset;
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            insets = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:i];
        }
        
        CGFloat interitemSpacing = self.minimumInteritemSpacing;
        if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            interitemSpacing = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:i];
        }
        
        //set header layoutAttributes
        UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (headerAttrs) {
            NSDictionary *value = @{UICollectionElementKindSectionHeader: headerAttrs};
            [self.supplementaryViewLayoutAttributesArray addObject:value];
        }
        
        //set column height
        NSMutableArray *heightArrayForSection = [NSMutableArray new];
        for (NSUInteger heightIndex = 0; heightIndex<numberOfItems; heightIndex++) {
            [heightArrayForSection addObject:@(insets.top + self.contentHeight)];
        }
        [self.columnHeights addObject:heightArrayForSection];
        
        //set item width
        CGFloat itemWidth = self.itemSize.width;
        if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
            itemWidth = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]].width;
        }
        [self.itemWidths addObject:@(itemWidth)];
        
        //set number per row
        NSUInteger numberPerRow = (CGRectGetWidth(self.collectionView.frame) - insets.left - insets.right + interitemSpacing) / (itemWidth + interitemSpacing);
        [self.columnCounts addObject:@(numberPerRow)];
        
        //set cell layoutAttributes
        for (NSUInteger j=0; j<numberOfItems; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.cellLayoutAttributesArray addObject:attrs];
        }
        self.contentHeight += insets.bottom;
        
        //set footer layoutAttributes
        UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (footerAttrs) {
            NSDictionary *value = @{UICollectionElementKindSectionFooter: footerAttrs};
            [self.supplementaryViewLayoutAttributesArray addObject:value];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //get UICollectionViewLayoutAttributes
    UICollectionViewLayoutAttributes *layoutAttrs = [super layoutAttributesForItemAtIndexPath:indexPath];
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    NSInteger targetColumn = 0;
    NSUInteger section = indexPath.section;
    
    CGFloat itemHeight = self.itemSize.height;
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemHeight = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath].height;
    }
    
    UIEdgeInsets insets = self.sectionInset;
    if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        insets = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    CGFloat interitemSpacing = self.minimumInteritemSpacing;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    CGFloat lineSpacing = self.minimumLineSpacing;
    if ([delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    CGFloat minColumnHeight = [self.columnHeights[section][targetColumn] floatValue];
    for (NSUInteger i=0; i < [self.columnCounts[section] integerValue]; i++) {
        CGFloat value = [self.columnHeights[section][i] floatValue];
        if (value < minColumnHeight) {
            minColumnHeight = value;
            targetColumn = i;
        }
    }
    
    CGFloat x = insets.left + ([self.itemWidths[section] floatValue] + interitemSpacing) * targetColumn;
    CGFloat y = minColumnHeight;
    if (indexPath.row >= [self.columnCounts[section] integerValue]) {
        //第二行开始才需要加上间距
        y += lineSpacing;
    }
    layoutAttrs.frame = CGRectMake(x, y, [self.itemWidths[section] floatValue], itemHeight);
    
    self.columnHeights[section][targetColumn] = @(CGRectGetMaxY(layoutAttrs.frame));
    if (self.contentHeight < [self.columnHeights[section][targetColumn] floatValue]) {
        self.contentHeight = [self.columnHeights[section][targetColumn] floatValue];
    }
    
    return layoutAttrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttrs = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if (layoutAttrs) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        
        CGSize newSize = CGSizeZero;
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                newSize = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
            } else {
                newSize = self.headerReferenceSize;
            }
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            if ([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
                newSize = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
            } else {
                newSize = self.footerReferenceSize;
            }
        }
        
        layoutAttrs.frame = CGRectMake(0, 0, newSize.width, newSize.height);
        self.contentHeight += newSize.height;
    }
    
    return layoutAttrs;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *rArray = [NSMutableArray array];
    //for cell
    for (UICollectionViewLayoutAttributes *cacheAttr in self.cellLayoutAttributesArray) {
        if (CGRectIntersectsRect(cacheAttr.frame, rect)) {
            [rArray addObject:cacheAttr];
        }
    }
    
    //for supplementaryView
    for (NSDictionary *cacheAttrDic in self.supplementaryViewLayoutAttributesArray) {
        UICollectionViewLayoutAttributes *cacheAttr = [[cacheAttrDic allValues] firstObject];
        if (CGRectIntersectsRect(cacheAttr.frame, rect)) {
            [rArray addObject:cacheAttr];
        }
    }
    
    return rArray;
}


@end


//
//  WaterFallFlowLayout.swift
//  UICollectionDemo
//
//  Created by xiabob on 16/12/3.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class WaterFallFlowLayout: UICollectionViewFlowLayout {
    
    private var itemWidth: CGFloat = 0
    //对应列的高度
    private var columnHeights = [CGFloat]()
    // collection view的content size的高
    private var contentHeight: CGFloat = 0
    private var columnCont = 3
    private var layoutAttributesArray = [Dictionary<IndexPath, UICollectionViewLayoutAttributes>]()
    
    //必须返回对应的contentSize，因为item尺寸是不定的，系统无法自动计算
    override var collectionViewContentSize: CGSize {
        let width = collectionView?.frame.width ?? UIScreen.main.bounds.width
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        if let collectionView = collectionView {
            //根据代理方法获取设置的minimumInteritemSpacing、minimumLineSpacing值
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            minimumInteritemSpacing = delegate?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: 0) ?? minimumInteritemSpacing
            minimumLineSpacing = delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: 0) ?? minimumLineSpacing
            
            //计算每一个item的宽度
            let viewWidth = collectionView.frame.width
            itemWidth = (viewWidth - sectionInset.left - sectionInset.right - CGFloat(columnCont-1)*minimumInteritemSpacing) / CGFloat(columnCont)
            contentHeight = 0
            
            columnHeights = Array(repeating: sectionInset.top, count: columnCont)
            layoutAttributesArray.removeAll()
            
            //根据IndexPath计算对应的UICollectionViewLayoutAttributes
            let sections = collectionView.numberOfSections
            for section in 0..<sections {
                let items = collectionView.numberOfItems(inSection: section)
                for item in 0..<items {
                    let indexPath = IndexPath(item: item, section: section)
                    let layoutAttrs = layoutAttributesForItem(at: indexPath)
                    if let layoutAttrs = layoutAttrs  {
                        layoutAttributesArray.append([indexPath: layoutAttrs])
                    } else {
                        continue
                    }
                }
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttrs = super.layoutAttributesForItem(at: indexPath)
        if let collectionView = collectionView {
            //通过代理方法获取对应indexpath的item的尺寸
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            let itemHeight = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath).height ?? 44
            
            //找到数组内目前高度最小的那一列，这样做是为了展示地均衡、美观，所以次序可能是打乱的的
            var targetColumn = 0
            var minColumnHeight = columnHeights[targetColumn]
            for i in 0..<columnCont {
                let value = columnHeights[i]
                if value < minColumnHeight {
                    minColumnHeight = value
                    targetColumn = i
                }
            }
            
            //开始计算坐标
            let x = sectionInset.left + (itemWidth + minimumInteritemSpacing) * CGFloat(targetColumn)
            var y = minColumnHeight
            if y != sectionInset.top {
                y += minimumLineSpacing
            }
            layoutAttrs?.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
            
            //更新高度信息
            columnHeights[targetColumn] = layoutAttrs!.frame.maxY
            if contentHeight < columnHeights[targetColumn] {
                contentHeight = columnHeights[targetColumn]
            }
        }
        
        return layoutAttrs
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        for attrDic in layoutAttributesArray {
            let value = attrDic.first!.value
            if value.frame.intersects(rect) {
                attrs.append(value)
            }
        }
        
        return attrs
    }
    
    //collectionView的布局发生了改变（比如横竖屏切换），是否需要刷新Layout。注意collectionView滚动的过程中，newBounds的y值一直在变化
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = collectionView {
            //横竖屏切换，width不同
            return !(collectionView.frame.width == newBounds.width)
        }
        
        return false
    }


}

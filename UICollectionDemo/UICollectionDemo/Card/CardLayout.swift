//
//  CardLayout.swift
//  UICollectionDemo
//
//  Created by xiabob on 16/12/3.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            minimumLineSpacing = delegate?.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: 0) ?? -20
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let items = super.layoutAttributesForElements(in: rect) else {return nil}
        for item in items {
            resetCellAttributes(item: item)
        }
        
        return items
    }
    
    private func resetCellAttributes(item: UICollectionViewLayoutAttributes) {
//        print(collectionView!.bounds)
        //注意，在滚动的过程中，collectionView的frame不变，但是它的bounds一直在改变，frame是相对于父视图而言，而bounds相对于自身而言
        let minY = collectionView!.bounds.minY + collectionView!.contentInset.top
        let finalY = max(minY, item.frame.minY)
        
        item.frame.origin.y = finalY
        item.zIndex = item.indexPath.row
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //由于collectionView在滑动过程中会不断修改cell的位置（保证吸顶效果），所以需要不断重新计算所有布局属性的信息
        return true
    }
}

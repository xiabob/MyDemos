//
//  SlideZoomInLayout.swift
//  UICollectionDemo
//
//  Created by xiabob on 16/12/3.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class SlideZoomInLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        if let collectionView = collectionView {
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout
            itemSize = delegate?.collectionView!(collectionView, layout: self, sizeForItemAt: IndexPath(item: 0, section: 0)) ?? itemSize
            let offset = (collectionView.frame.width - itemSize.width) / CGFloat(2)
            //使得第一个、最后一个cell也能居中
            sectionInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
            scrollDirection = .horizontal
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //滑动的过程中需要调整cell的缩放
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {return nil}
        
        //collectionView中心位置
        let center = collectionView!.bounds.midX
        for item in attributes {
            let offset = abs(item.center.x - center)
            //根据cell与中心点间的间距来缩放大小
            let scale = 1 - offset/(collectionView!.frame.width)
            item.transform = item.transform.scaledBy(x: scale, y: scale)
        }
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // 计算出最终显示的矩形框
        let targetBounds = CGRect(origin: proposedContentOffset, size: collectionView!.bounds.size)
        
        guard let attributes = super.layoutAttributesForElements(in: targetBounds)  else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        //计算最终collectionView的中心位置
        let center = targetBounds.midX
        
        //找到距离中心点最近的cell对应的item
        var minOffset = CGFloat.greatestFiniteMagnitude
        for item in attributes {
            if abs(minOffset) > abs(item.center.x - center) {
                minOffset = item.center.x - center
            }
        }
        
        //修正proposedContentOffset，使得中心的cell居中
        return CGPoint(x: proposedContentOffset.x+minOffset, y: proposedContentOffset.y)

    }
    
}

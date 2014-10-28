//
//  CollectionViewLargeLayout.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//


import Foundation
import UIKit

class CollectionViewLargeLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init();
        self.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 4.0
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        println("proposedContentOffset.x = \(proposedContentOffset.x) \t proposedContentOffset.y = \(proposedContentOffset.y)")
        println("velocity.x = \(velocity.x) \t velocity.y = \(velocity.y)")
        
        var offsetAdjustment: CGFloat = CGFloat.max
        var horizontalCenter: CGFloat = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0)
        var targetRect: CGRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView!.bounds.size.width, self.collectionView!.bounds.size.height)
     
        var layoutAttrArr : Array<AnyObject>! = layoutAttributesForElementsInRect(targetRect)
        for layoutAttributes in layoutAttrArr {
            println("lol");
            if ((layoutAttributes as UICollectionViewLayoutAttributes).representedElementCategory != UICollectionElementCategory.Cell) {
                println("ok");
                continue; // skip headers
            }
            
            var itemHorizontalCenter: CGFloat = (layoutAttributes as UICollectionViewLayoutAttributes).center.x;
            println("itemHorizontalCenter = \(itemHorizontalCenter)")
            if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
                println("offsetAdjustment = \(offsetAdjustment)")
                (layoutAttributes as UICollectionViewLayoutAttributes).alpha = 0;
            }
        }
        
        println("proposedContentOffset.x = \(proposedContentOffset.x)\toffsetAdjustment = \(offsetAdjustment)\tproposedContentOffset.y = \(proposedContentOffset.y)")
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    }

}
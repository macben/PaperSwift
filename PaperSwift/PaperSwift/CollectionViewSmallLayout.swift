//
//  CollectionViewSmartLayout.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSmallLayout: UICollectionViewFlowLayout {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init();
        //self.itemSize = CGSizeMake(142, 254)
        self.itemSize = CGSizeMake(213, 381)
        //self.sectionInset = UIEdgeInsetsMake(314, 2, 0, 2)
        self.sectionInset = UIEdgeInsetsMake(240, 2, 0, 2)
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 2.0
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }
}
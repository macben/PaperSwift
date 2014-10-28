//
//  CollectionViewController.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//

import Foundation
import UIKit

let MAX_COUNT = 20
let CELL_ID = "CELL_ID"

class CollectionViewController: UICollectionViewController {
    
    override init(collectionViewLayout layout: UICollectionViewLayout!) {
        super.init(collectionViewLayout: layout)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:CELL_ID)
        collectionView.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as UICollectionViewCell
 
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.cornerRadius = 4.0
        cell.clipsToBounds = true
        
        var backgroundView: UIImageView = UIImageView(image: UIImage(named: "2"))
        cell.backgroundView = backgroundView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MAX_COUNT
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func nextViewControllerAtPoint(point: CGPoint)->UICollectionViewController? {
        return nil;
    }

    override func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout! {
        var transitionLayout: TransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return transitionLayout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //    self.collectionView.decelerationRate = self.class != [HAPaperCollectionViewController class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
       collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
    }
}



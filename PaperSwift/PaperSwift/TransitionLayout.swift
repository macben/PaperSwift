//
//  TransitionLayout.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//

import Foundation
import UIKit

var kOffsetH: NSString = "offsetH"
var kOffsetV: NSString = "offsetV"

class TransitionLayout: UICollectionViewTransitionLayout {
    
    var offset: UIOffset!
    
    override init(currentLayout: UICollectionViewLayout, nextLayout newLayout: UICollectionViewLayout) {
        super.init(currentLayout: currentLayout, nextLayout: newLayout)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Définir le progrès de l'achèvement de la transition en cours.
    func setTransitionProgress(transitionProgress: CGFloat) {
        super.transitionProgress = transitionProgress
        var offsetH: CGFloat = valueForAnimatedKey(kOffsetH)
        var offsetV: CGFloat = valueForAnimatedKey(kOffsetV)
        self.offset = UIOffsetMake(offsetH, offsetV)
    }
    
    // Appelé par la classe TransitionController tout en actualisant sa progression de la transition, animating
    // animer les éléments de la vue dans une collection de mode de pile
    func setOffset(offset: UIOffset) {
        // Stocker les valeurs à virgule flottante avec des clés significatifs pour notre objet de transition de mise en page
        updateValue(offset.horizontal, forAnimatedKey: kOffsetH)
        updateValue(offset.vertical, forAnimatedKey: kOffsetV)
        self.offset = offset
    }
    
    
    // retourner les attributs de mise en page pour l'ensemble des cellules et des points de vue dans le rectangle spécifié
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes: NSArray = layoutAttributesForElementsInRect(rect)!
        
        for currentAttribute in attributes {
            var currentCenter: CGPoint = (currentAttribute as UICollectionViewLayoutAttributes).center
            var updatedCenter: CGPoint = CGPointMake(currentCenter.x, currentCenter.y + self.offset.vertical)
            (currentAttribute as UICollectionViewLayoutAttributes).center = updatedCenter
        }
        
        return attributes;
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        // Renvoie les attributs de mise en forme de l'élément à l'emplacement d'index spécifié
        var attributes: UICollectionViewLayoutAttributes = layoutAttributesForItemAtIndexPath(indexPath)
        var currentCenter: CGPoint = attributes.center;
        var updatedCenter: CGPoint = CGPointMake(currentCenter.x + self.offset.horizontal, currentCenter.y + self.offset.vertical);
        attributes.center = updatedCenter;
        
        return attributes;
    }
}














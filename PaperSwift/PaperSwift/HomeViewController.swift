//
//  ViewController.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//

import UIKit

class HomeViewController: CollectionViewController {

    var galleryImages: NSArray!
    var slide = 0
    var topImage: UIImageView!
    var mainView: UIView!
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var vc: UIViewController = nextViewControllerAtPoint(CGPointZero)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout!) {
        super.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func nextViewControllerAtPoint(point: CGPoint) -> UICollectionViewController? {
        // Nous pourrions avoir plusieurs sections piles et trouver la bonne
        var largeLayout: CollectionViewLargeLayout = CollectionViewLargeLayout()
        var nextCollectionViewController: CollectionViewController = CollectionViewController(collectionViewLayout: largeLayout)
        nextCollectionViewController.useLayoutToLayoutNavigationTransitions = true
        return nextCollectionViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        galleryImages = ["one.jpg", "two.jpg", "three.png", "five.jpg", "one.jpg"]
        
        mainView = UIView(frame: self.view.bounds)
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 4.0
        self.view.insertSubview(mainView, belowSubview: self.collectionView)
        
        topImage = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)))
        mainView.addSubview(topImage)
        
        topImage.contentMode = UIViewContentMode.ScaleAspectFill
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = topImage.bounds
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor, UIColor(white: 0, alpha: 0).CGColor]
        topImage.layer.insertSublayer(gradient, atIndex: 0)
        
        // Content perfect pixel
        var perfectPixelContent: UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(topImage.bounds), 1))
        perfectPixelContent.backgroundColor = UIColor(white: 1, alpha: 0.2)
        topImage.addSubview(perfectPixelContent)

        // Label logo
        var logo: UILabel = UILabel(frame: CGRectMake(15, 30, 290, 0))
        logo.backgroundColor = UIColor.clearColor()
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Helvetica-Bold", size: 22)
        logo.text = "Paper"
        logo.sizeToFit()
        
        // Label Shadow
        logo.clipsToBounds = false
        logo.layer.shadowOffset = CGSizeMake(0, 0)
        logo.layer.shadowColor = UIColor.blackColor().CGColor
        logo.layer.shadowRadius = 1.0
        logo.layer.shadowOpacity = 0.6
        mainView.addSubview(logo)
        
        // Label Title
        var title: UILabel = UILabel(frame: CGRectMake(15, logo.frame.origin.y + CGRectGetHeight(logo.frame) + 8, 290, 0))
        title.backgroundColor = UIColor.clearColor()
        title.textColor = UIColor.whiteColor()
        title.font = UIFont(name: "Helvetica-Bold", size: 13)
        title.text = "Mukesh Mandora"
        title.sizeToFit()

        // Label Shadow
        title.clipsToBounds = false;
        title.layer.shadowOffset = CGSizeMake(0, 0)
        title.layer.shadowColor = UIColor.blackColor().CGColor
        title.layer.shadowRadius = 1.0
        title.layer.shadowOpacity = 0.6
        mainView.addSubview(title)
        
        // Label SubTitle
        var subTitle: UILabel = UILabel(frame: CGRectMake(15, title.frame.origin.y + CGRectGetHeight(title.frame), 290, 0))
        subTitle.backgroundColor = UIColor.clearColor()
        subTitle.textColor = UIColor.whiteColor()
        subTitle.font = UIFont(name: "Helvetica", size: 13)
        subTitle.text = "Extension Of HAPaperViewController(Heberti Almeida)"
        subTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        subTitle.numberOfLines = 0
        subTitle.sizeToFit()
        
        // Label Shadow
        subTitle.clipsToBounds = false;
        subTitle.layer.shadowOffset = CGSizeMake(0, 0)
        subTitle.layer.shadowColor = UIColor.blackColor().CGColor
        subTitle.layer.shadowRadius = 1.0
        subTitle.layer.shadowOpacity = 0.6
        mainView.addSubview(subTitle)
        
        // First Load
        changeSlide()
        
        //var timer: NSTimer = NSTimer(timeInterval: 5.0, target: self, selector: Selector("changeSlide"), userInfo: nil, repeats: true)
        //NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    func changeSlide() {
        if (slide > galleryImages.count-1) {
            slide = 0
        }

        var toImage: UIImage = UIImage(named: galleryImages[slide] as NSString)!
        UIView.transitionWithView(mainView, duration: 0.6, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.topImage.image = toImage;

        }, completion: nil)
      
        slide++
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


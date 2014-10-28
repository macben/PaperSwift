//
//  TransitionController.swift
//  MacBen
//
//  Created by ben on 24/10/2014.
//  Copyright (c) 2014 meteomodem. All rights reserved.
//

import Foundation
import UIKit

protocol TransitionControllerDelegate {
    func interactionBeganAtPoint(point: CGPoint)
}

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIGestureRecognizerDelegate{
    var delegate: TransitionControllerDelegate!
    var hasActiveInteraction: Bool! = false
    var transitionLayout: TransitionLayout!
    var context: UIViewControllerContextTransitioning!
    var initialPinchDistance: CGFloat!
    var initialPinchPoint: CGPoint!
    var initialScale: CGFloat!
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    var navigationOperation: UINavigationControllerOperation!

    var collectionView: UICollectionView!

    func initWithCollectionView(collectionView: UICollectionView)->TransitionController? {
        //println("initWithCollectionView")
        var pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinch:"))
        collectionView.addGestureRecognizer(pinchGesture)
        var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target:self, action: Selector("oneFingerGesture:"))
        
        panGestureRecognizer.delegate = self;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        collectionView.addGestureRecognizer(panGestureRecognizer)
        
        self.collectionView = collectionView
        return self
    }
    
    //mark - UIGestureRecognizerDelegate
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            //println("shouldRecognizeSimultaneouslyWithGestureRecognizer")
            return true
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // rien
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        //println("startInteractiveTransition")
        self.context = transitionContext
        var fromCollectionViewController: UICollectionViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UICollectionViewController
        var toCollectionViewController: UICollectionViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UICollectionViewController
        var containerView: UIView = transitionContext.containerView()
        containerView.addSubview(toCollectionViewController.view)
        self.transitionLayout = fromCollectionViewController.collectionView.startInteractiveTransitionToCollectionViewLayout(toCollectionViewController.collectionViewLayout  as TransitionLayout, completion: { (didFinish, didComplete) -> Void in
            self.context.completeTransition(didComplete)
            self.transitionLayout = nil
            self.context = nil
            self.hasActiveInteraction = false
        })  as TransitionLayout
    }
    
    func updateWithProgress(progress: CGFloat, andOffset offset:UIOffset) {
        //println("updateWithProgress")
        if (self.context != nil &&  // we must have a valid context for updates
            ((progress != self.transitionLayout.transitionProgress) || !UIOffsetEqualToOffset(offset, self.transitionLayout.offset)))
        {
            self.transitionLayout.offset = offset
            self.transitionLayout.transitionProgress = progress
            self.transitionLayout.invalidateLayout()
            self.context.updateInteractiveTransition(progress)
        }

    }
    
    func updateWithProgress(progress: CGFloat) {
        //println("updateWithProgress")
        if (self.context != nil && ((progress != self.transitionLayout.transitionProgress)))
        {
            self.transitionLayout.transitionProgress = progress
            self.transitionLayout.invalidateLayout()
            self.context.updateInteractiveTransition(progress)
        }
    }
    
    func endInteractionWithSuccess(success: Bool) {
        //println("endInteractionWithSuccess")
        if (self.context == nil) {
            self.hasActiveInteraction = false
        } else if ((self.transitionLayout.transitionProgress > 0.1) && success) {
            self.collectionView?.finishInteractiveTransition()
            self.context.finishInteractiveTransition()
        } else {
            self.collectionView?.cancelInteractiveTransition()
            self.context.cancelInteractiveTransition()
        }

    }
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        //println("handlePinch")
        // here we want to end the transition interaction if the user stops or finishes the pinch gesture
        if (sender.state == UIGestureRecognizerState.Ended) {
            endInteractionWithSuccess(true)
        }else if (sender.state == UIGestureRecognizerState.Cancelled) {
            endInteractionWithSuccess(false)
        }else if (sender.numberOfTouches() == 2) {
            // here we expect two finger touch
            var point: CGPoint      // the main touch point
            var point1: CGPoint     // location of touch #1
            var point2: CGPoint     // location of touch #2
            var distance: CGFloat   // computed distance between both touches
            
            // return the locations of each gesture’s touches in the local coordinate system of a given view
            point1 = sender.locationOfTouch(0, inView: sender.view)
            point2 = sender.locationOfTouch(1, inView: sender.view)
            distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
            
            // get the main touch point
            point = sender.locationInView(sender.view)
            
            if (sender.state == UIGestureRecognizerState.Began) {
                // start the pinch in our out
                if (!(self.hasActiveInteraction))
                {
                    self.initialPinchDistance = distance
                    self.initialPinchPoint = point
                    self.hasActiveInteraction = true    // the transition is in active motion
                    self.delegate?.interactionBeganAtPoint(point)
                }
            }
            
            if (self.hasActiveInteraction!) {
                if (sender.state == UIGestureRecognizerState.Changed) {
                    // update the progress of the transtition as the user continues to pinch
                    var delta: CGFloat = distance - self.initialPinchDistance
                    var offsetX: CGFloat = point.x - self.initialPinchPoint.x
                    var offsetY: CGFloat = point.y - self.initialPinchPoint.y + delta / 3.14159265359
                    var offsetToUse: UIOffset = UIOffsetMake(offsetX, offsetY);
                    
                    var distanceDelta: CGFloat = distance - self.initialPinchDistance;
                    if (self.navigationOperation == UINavigationControllerOperation.Pop) {
                        distanceDelta = -distanceDelta;
                    }
                    
                    var progress: CGFloat = max(min(((distanceDelta + sender.velocity * 3.14159265359) / 250), 1.0), 0.0)
                    updateWithProgress(progress, andOffset: offsetToUse)
                }
            }
        }
    }
    
    func oneFingerGesture(sender: UIPanGestureRecognizer) {
        //println("oneFingerGesture")
        
        // here we want to end the transition interaction if the user stops or finishes the pinch gesture
        if (sender.state == UIGestureRecognizerState.Ended) {
            endInteractionWithSuccess(true)
        } else if (sender.state == UIGestureRecognizerState.Cancelled) {
            endInteractionWithSuccess(false)
        } else {
            var velocity: CGPoint = sender.velocityInView(sender.view)
            var isVerticalGesture: Bool = fabs(velocity.y) > fabs(velocity.x)
            if (isVerticalGesture) {
                //println("isVerticalGesture")
                var point: CGPoint = sender.locationInView(sender.view)
                var distance: CGFloat = 0.0
                var progress: CGFloat = 0.0
                
                distance = sqrt((point.x - sender.translationInView(sender.view!).x)
                             * (point.x - sender.translationInView(sender.view!).x)
                             + (point.y - sender.translationInView(sender.view!).y)
                             * (point.y - sender.translationInView(sender.view!).y))

                if (sender.state == UIGestureRecognizerState.Began) {
                    // start the pinch in our out
                    if (!self.hasActiveInteraction)
                    {
                        self.initialPinchDistance = distance
                        self.initialPinchPoint = point
                        self.hasActiveInteraction = true    // the transition is in active motion
                        self.delegate.interactionBeganAtPoint(point)
                    }
                }
                
                if (self.hasActiveInteraction!) {
                    if (sender.state == UIGestureRecognizerState.Changed) {
                        var delta: CGFloat = distance - self.initialPinchDistance
                        progress = (sender.translationInView(sender.view!).y) * 3.14159265359 / sender.view!.bounds.size.width * 1.0
                        progress = min(1.0, max(0.0, abs(progress)))
                        
                        var offsetX: CGFloat = point.x - self.initialPinchPoint.x;
                        var offsetY: CGFloat = (point.y - self.initialPinchPoint.y) + delta / 3.14159265359;
                        var offsetToUse: UIOffset = UIOffsetMake(offsetX, offsetY);
                        updateWithProgress(progress)
                    }
                }
            }
        }
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        //println("pan")
        enum UIPanGestureRecognizerDirection: Int{
            case Undefined = 0
            case Up = 1
            case Down = 2
            case Left = 3
            case Right = 4
        }
        
        var direction: UIPanGestureRecognizerDirection = UIPanGestureRecognizerDirection.Undefined
        switch (sender.state) {
            case UIGestureRecognizerState.Began :
                if (direction == UIPanGestureRecognizerDirection.Undefined) {
                    
                    var velocity: CGPoint = sender.velocityInView(sender.view)
                    var isVerticalGesture: Bool = fabs(velocity.y) > fabs(velocity.x);
                    
                    if (isVerticalGesture) {
                        if (velocity.y > 0) {
                            direction = UIPanGestureRecognizerDirection.Down
                        } else {
                            direction = UIPanGestureRecognizerDirection.Up
                        }
                    } else {
                        if (velocity.x > 0) {
                            direction = UIPanGestureRecognizerDirection.Right
                        } else {
                            direction = UIPanGestureRecognizerDirection.Left
                        }
                    }
                }
                
                break;
            case UIGestureRecognizerState.Changed:
                switch (direction) {
                    case UIPanGestureRecognizerDirection.Up:
                        handleDownwardsGesture(sender)
                        break;
                    case UIPanGestureRecognizerDirection.Down:
                        handleDownwardsGesture(sender)
                        break;
                    case UIPanGestureRecognizerDirection.Left:
                        handleLeftGesture(sender)
                        break;
                    case UIPanGestureRecognizerDirection.Right:
                        handleRightGesture(sender)
                        break;
                    default:
                        break;
                }
            case UIGestureRecognizerState.Ended:
                direction = UIPanGestureRecognizerDirection.Undefined;
                break;
            default:
                break;
        }
    }
    
    func handleUpwardsGesture(sender: UIPanGestureRecognizer) {
        println("up")
    }
    
    
    func handleDownwardsGesture(sender: UIPanGestureRecognizer) {
        println("down")
    }
    
    
    func handleLeftGesture(sender: UIPanGestureRecognizer) {
        println("left")
    }
    
    
    func handleRightGesture(sender: UIPanGestureRecognizer) {
        println("right")
    }
}
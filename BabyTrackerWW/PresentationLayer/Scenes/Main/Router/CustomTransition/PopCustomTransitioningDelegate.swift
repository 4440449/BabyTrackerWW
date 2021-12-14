//
//  TransitioningDelegate.swift
//  BabyTrackerWW
//
//  Created by Max on 12.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class PopCustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PopPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopDismissAnimator()
    }
    
}

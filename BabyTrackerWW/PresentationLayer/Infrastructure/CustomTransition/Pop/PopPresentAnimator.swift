//
//  PopPresentAnimator.swift
//  BabyTrackerWW
//
//  Created by Max on 14.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class PopPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to)?.view
            else { return }
        to.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveLinear], animations: {
            to.transform = .identity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

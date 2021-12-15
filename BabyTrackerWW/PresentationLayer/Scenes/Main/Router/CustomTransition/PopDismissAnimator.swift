//
//  PopDismissAnimator.swift
//  BabyTrackerWW
//
//  Created by Max on 14.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class PopDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from)?.view
            else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveLinear], animations: {
            from.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            from.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
}

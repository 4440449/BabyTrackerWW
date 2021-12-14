//
//  PopPresentationController.swift
//  BabyTrackerWW
//
//  Created by Max on 14.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class PopPresentationController: UIPresentationController {
    
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
    
    @objc private func didTap() {
       presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return
            CGRect(x: 200, y: 100, width: 250, height: 85)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin() //
        
        guard let containerView = containerView,
            let presentedView = presentedView
            else { return }
        
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.layer.cornerRadius = 5
        
        dimmView.frame = containerView.frame
        
        containerView.addSubview(dimmView)
        containerView.addSubview(presentedView)
    }
    
}

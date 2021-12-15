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
        view.addGestureRecognizer(panGesture)
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
    private lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
    
    
    @objc private func didTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began: presentedViewController.dismiss(animated: true, completion: nil)
        default: return
        }
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return
            CGRect(x: 200, y: 90, width: 200, height: 85)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin() //
        
        guard let containerView = containerView,
            let presentedView = presentedView
            else { return }
        
        dimmView.frame = containerView.frame
        presentedView.frame = frameOfPresentedViewInContainerView

        containerView.addSubview(dimmView)
        containerView.addSubview(presentedView)
    }
    
}




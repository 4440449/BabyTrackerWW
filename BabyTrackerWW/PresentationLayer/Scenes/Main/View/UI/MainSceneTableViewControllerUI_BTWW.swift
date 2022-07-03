//
//  MainSceneTableViewControllerUI_BTWW.swift
//  BabyTrackerWW
//
//  Created by Maxim on 17.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import UIKit


// MARK: - UI

extension MainSceneTableViewController_BTWW {
    
    // MARK: - Gestures
    
    func setupNavBarGestures() {
        navigationController?.navigationBar.addGestureRecognizer(directionPan)
    }
    
    func manageGestures() {
        if (!tableView.isEditing && activityIndicator.isHidden) {
            enableNavBarGestures()
        } else {
            disableNavBarGestures()
        }
    }
    
    private func enableNavBarGestures() {
        navigationController?.navigationBar.gestureRecognizers?.forEach {
            if $0 == directionPan {
                $0.isEnabled = true
            }
        }
    }
    
     func disableNavBarGestures() {
        navigationController?.navigationBar.gestureRecognizers?.forEach {
            if $0 == directionPan {
                $0.isEnabled = false
            }
        }
    }
    
    @objc func didPan(_ panGesture: UIPanGestureRecognizer) {
        guard let centerX = navigationController?.navigationBar.center.x else { return }
        guard let midXbounds = navigationController?.navigationBar.bounds.midX else { return }
        let positiveXOffset = midXbounds + 90
        let negativeXOffset = midXbounds - 90
        let gestureOffset = panGesture.translation(in: navigationController?.navigationBar.superview)
        //        let newXPosition = gestureOffset.x / 1.5 + centerX
        let newXPosition = gestureOffset.x + centerX
        if #available(iOS 15, *) {
            navigationController?.view.center.x = newXPosition
        } else {
            navigationController?.navigationBar.center.x = newXPosition
            panGesture.setTranslation(.zero, in: navigationController?.navigationBar.superview)
        }
        
        switch panGesture.state {
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                if #available(iOS 15, *) {
                    self.navigationController?.view.frame.origin.x = .zero
                } else {
                    self.navigationController?.navigationBar.frame.origin.x = .zero
                }
                if newXPosition > positiveXOffset {
                    self.feedbackGenerator.selectionChanged()
                    self.viewModel.swipe(gesture: .left)
                } else if newXPosition < negativeXOffset {
                    self.feedbackGenerator.selectionChanged()
                    self.viewModel.swipe(gesture: .right)
                } else {
                    return
                }
            })
        default:
            return
        }
    }
    
    
    // MARK: - Navigation bar
    
    func setupNavBarButtons() {
        closeSceneOutletButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(closeSceneButton))
        changeDateOutletButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(changeDateButton))
        addNewOutletButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addNewButton))
        cancelOutletButton = UIBarButtonItem (title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
        saveOutletButton = UIBarButtonItem (title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        editOutletButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editButton))
    }
    
    func manageDisplayNavBarButtons() {
        guard activityIndicator.isHidden else { showLoadingModeNavBarButtons(); return }
        switch tableView.isEditing {
        case true: showEditModeNavBarButtons()
        case false: showNotEditModeNavBarButtons()
        }
    }
    
    private func showEditModeNavBarButtons() {
        navigationItem.leftBarButtonItems = [cancelOutletButton]
        navigationItem.rightBarButtonItems = [saveOutletButton]
        navigationItem.leftBarButtonItems?.forEach { $0.isEnabled = true }
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
    }
    
    private func showNotEditModeNavBarButtons() {
        navigationItem.leftBarButtonItems = [closeSceneOutletButton]
        navigationItem.rightBarButtonItems = viewModel.getNumberOfLifeCycles() != 0 ? [addNewOutletButton, editOutletButton, changeDateOutletButton] : [addNewOutletButton, changeDateOutletButton]
        navigationItem.leftBarButtonItems?.forEach { $0.isEnabled = true }
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
    }
    
    private func showLoadingModeNavBarButtons() {
        navigationItem.leftBarButtonItems?.forEach { $0.isEnabled = false }
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
    }
    
    
    // MARK: - Activity indicator
    
    func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: tableView.bounds.midX,
                                           y: tableView.bounds.midY/1.5)
        activityIndicator.style = .large
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        tableView.addSubview(activityIndicator)
    }
    
    func startLoadingMode() {
        activityIndicator.startAnimating()
    }
    
    func stopLoadingMode() {
        activityIndicator.stopAnimating()
    }
    
}

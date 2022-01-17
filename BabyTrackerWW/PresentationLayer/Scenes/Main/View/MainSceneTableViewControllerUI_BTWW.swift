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
    
    private func disableNavBarGestures() {
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
        navigationController?.navigationBar.center.x = newXPosition
        panGesture.setTranslation(.zero, in: navigationController?.navigationBar.superview)
        
        switch panGesture.state {
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                self.navigationController?.navigationBar.frame.origin.x = .zero
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
        changeDateOutletButton = UIBarButtonItem(title: "Изменить дату", style: .plain, target: self, action: #selector(changeDateButton))
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
        navigationItem.leftBarButtonItems = [changeDateOutletButton]
        navigationItem.rightBarButtonItems = viewModel.getNumberOfLifeCycles() != 0 ? [addNewOutletButton, editOutletButton] : [addNewOutletButton]
        navigationItem.leftBarButtonItems?.forEach { $0.isEnabled = true }
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
    }
    
    private func showLoadingModeNavBarButtons() {
        navigationItem.leftBarButtonItems?.forEach { $0.isEnabled = false }
        navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
    }
    
    
    // MARK: - Activity indicator
    
    func setupActivityIndicator() {
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.midX,
                                           y: UIScreen.main.bounds.midY)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = .systemGray
        tableView.addSubview(activityIndicator)
    }
    
    func startLoadingMode() {
        //                showBlure()
        activityIndicator.startAnimating()
    }
    
    func stopLoadingMode() {
        hideBlure()
        activityIndicator.stopAnimating()
    }
    
    
    // MARK: - Blure effect
    
    func setupBlureEffect() {
        let style: UIBlurEffect.Style = traitCollection.userInterfaceStyle == .dark ?
            .systemThinMaterialDark : .systemThinMaterialLight
        blure.effect = UIBlurEffect(style: style)
        //        blure.frame = tableView.bounds
        //        blure.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blure.alpha = 0.7
        //        tableView.addSubview(blure)
    }
    
    func removeBlureEffect() {
        blure.removeFromSuperview()
    }
    
    private func showBlure() {
        blure.isHidden = false
    }
    
    private func hideBlure() {
        blure.isHidden = true
    }
    
    
    // MARK: - Background
    
    func setupSuperviewBackgroudColor() {
        tableView.superview?.backgroundColor = .systemBackground
    }
    
    
}
//
//  MainSceneTableViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class MainSceneTableViewController_BTWW: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Dependencies
    
    private let configurator = MainSceneConfigurator_BTWW()
    var viewModel: MainSceneViewModelProtocol_BTWW!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureScene(view: self)
        setupTableView()
        setupNavBarButtons()
        setupNavBarGestures()
        setupObservers()
        viewModel.viewDidLoad()
        //        tableView.panGestureRecognizer.addTarget(self, action: #selector(scroll))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set obs
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Delete obs
    }
    
    
    //
    //    @objc func scroll(_ pan: UIPanGestureRecognizer) {
    //
    //        switch pan.state {
    //
    //        case .began: return//print("began")
    //        case .changed: print("changed");
    //            print("tableView.contentOffset == \(tableView.contentOffset)")
    //
    //        case .ended:
    //            print("ended");
    //            print("tableView.contentOffset == \(tableView.contentOffset)")
    //
    //        case .recognized:
    //            print("recognized");
    //            print("tableView.contentOffset == \(tableView.contentOffset)")
    //
    //        case .possible: print("possible")
    //        case .failed: print("failed")
    //        case .cancelled: print("cancelled")
    ////            sleep(UInt32(0.1))
    ////            print("tableView.bounds.height == \(tableView.bounds.height)")
    ////            navigationController?.navigationBar.layoutSubviews();
    ////            print("navigationController?.navigationBar.bounds.height == \(navigationController?.navigationBar.bounds.height)")
    //        default: return
    //        }
    //
    //    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        if let sceneDelegate =
            UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.sceneState.subscribe(observer: self) { [weak self] sceneState in
                switch sceneState {
                case .foreground:
                    self?.setupSuperviewBackgroudColor()
                    self?.setupBlureEffect()
                    self?.setupActivityIndicator()
                case .background:
                    self?.removeBlureEffect()
                    self?.removeActivityIndicator()
                }
            }
        }
        
        viewModel.tempLifeCycle.subscribe(observer: self) { [weak self] _ in
            self?.reloadData()
        }
        
        viewModel.isLoading.subscribe(observer: self) { [weak self] isLoading in
            switch isLoading {
            case .true:
                self?.startActivity();
                self?.manageDisplayNavBarButtons();
                self?.manageGestures()
            case .false:
                self?.stopActivity();
                self?.manageDisplayNavBarButtons();
                self?.manageGestures()
            }
        }
        
        viewModel.error.subscribe(observer: self) { [weak self] error in
            self?.showErrorAlert(errorMessage: error)
        }
    }
    
    private func reloadData() {
        navigationController?.navigationBar.topItem?.title = viewModel.getDate()
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.tableView.reloadData()
        })
    }
    
    
    // MARK: - UI
    
    private let activityIndicator = UIActivityIndicatorView()
    private let blure = UIVisualEffectView()
    
    
    // MARK: - Navigation Bar
    
    private var changeDateOutletButton: UIBarButtonItem!
    private var addNewOutletButton: UIBarButtonItem!
    private var cancelOutletButton: UIBarButtonItem!
    private var saveOutletButton: UIBarButtonItem!
    private var editOutletButton: UIBarButtonItem!
    
    
    // MARK: - System
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    
    // MARK: - Gestures
    
    private lazy var directionPan = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(didPan(_:)))
    
    
    // MARK: - Table view
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfLifeCycles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSceneTableViewCell_BTWW.identifier, for: indexPath) as! MainSceneTableViewCell_BTWW
        cell.label.text = viewModel.getCellLabel(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveRow(source: sourceIndexPath.row, destination: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
            viewModel.didSelectRow(at: indexPath.row, vc: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing else { return false }
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        print("indexPath == \(indexPath.row)")
        viewModel.deleteRow(at: indexPath.row)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.prepare(for: segue, sourceVC: self)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - UIAlert
    
    private func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    deinit {
        // Root VC
    }
    
}




// MARK: - Internal setup - Behaviours -

extension MainSceneTableViewController_BTWW {
    
    // MARK: - Gestures
    
    private func setupNavBarGestures() {
        navigationController?.navigationBar.addGestureRecognizer(directionPan)
    }
    
    private func manageGestures() {
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
    
    private func setupNavBarButtons() {
        changeDateOutletButton = UIBarButtonItem(title: "Изменить дату", style: .plain, target: self, action: #selector(changeDateButton))
        changeDateOutletButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(changeDateButton))
        addNewOutletButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addNewButton))
        cancelOutletButton = UIBarButtonItem (title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
        saveOutletButton = UIBarButtonItem (title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        editOutletButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editButton))
    }
    
    private func manageDisplayNavBarButtons() {
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
    
    
    @IBAction private func changeDateButton(_ sender: Any) {
        performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction private func addNewButton(_ sender: Any) {
        performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        viewModel.cancelChanges()
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    @IBAction private func saveButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
        viewModel.saveChanges()
    }
    
    @IBAction private func editButton(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    
    // MARK: - Activity indicator
    
    private func setupActivityIndicator() {
        print("setupActivityIndicator")
        let color: UIColor = .systemGray
//        print("superView == \(tableView.superview!) ... \(tableView.superview!.center)")
//        print("superView == \(tableView.frame) ... \(tableView.center)")
        
        activityIndicator.center = CGPoint(x: 207, y: 448)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = color
        tableView.addSubview(activityIndicator)
//        print(activityIndicator.center)
    }
    
    private func removeActivityIndicator() {
        print("removeActivityIndicator")
        activityIndicator.removeFromSuperview()
    }
    
    private func startActivity() {
        //        showBlure()
        activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        hideBlure()
        activityIndicator.stopAnimating()
    }
    
    
    // MARK: - Blure effect
    
    private func setupBlureEffect() {
        print("setupBlureEffect")
        // if #available(iOS 13.0, *)
        let style: UIBlurEffect.Style = self.traitCollection.userInterfaceStyle == .dark ?
            .systemThinMaterialDark : .systemThinMaterialLight
        let blurEffect = UIBlurEffect(style: style)
        blure.effect = blurEffect
        //        blure.frame = tableView.frame
        blure.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blure.alpha = 0.7
        //        tableView.addSubview(blure)
        //        navigationController?.navigationBar.addSubview(blure)
        
    }
    
    private func removeBlureEffect() {
        print("removeBlureEffect")
        blure.removeFromSuperview()
    }
    
    private func showBlure() {
        blure.isHidden = false
    }
    
    private func hideBlure() {
        blure.isHidden = true
    }
    
    
    // MARK: -
    
    private func setupSuperviewBackgroudColor() {
        let color: UIColor = .systemBackground
        tableView.superview?.backgroundColor = color
    }
    
    
}





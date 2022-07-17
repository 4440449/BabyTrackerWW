//
//  MainSceneTableViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class MainSceneTableViewController_BTWW: UITableViewController,
                                               UIPopoverPresentationControllerDelegate,
                                               MainScenePresenterOutputPrtotocol_BTWW {
    
    // MARK: - Dependencies
    
    private let configurator = MainSceneConfigurator_BTWW()
    private var presenter: MainScenePresenterInputProtocol!
    
    func setupPresenter(_ presenter: MainScenePresenterInputProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureScene(view: self)
        setupTableView()
        setupNavBarAppearance()
        setupNavBarButtons()
        setupNavBarGestures()
        setupActivityIndicator()
        setupAlert()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Delete obs
    }
    
    
    // MARK: - Input data flow / PresenterOutput interface

    func reloadData() {
        self.internalReloadData()
    }
    
    private func internalReloadData() {
        navigationController?.navigationBar.topItem?.title = presenter.getDate()
        UIView.transition(with: tableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: {
            self.tableView.reloadData()
        })
    }
    
    
    func newLoadingState(_ isLoading: Bool) {
        switch isLoading {
        case true:
            self.startLoadingMode();
            self.manageDisplayNavBarButtons();
            self.manageGestures()
        case false:
            self.stopLoadingMode();
            self.manageDisplayNavBarButtons();
            self.manageGestures()
        }
    }
    
    func newError(_ message: String) {
        guard !message.isEmpty else { return }
        alert.message = message
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Activity + VisualEffects
    
    private var alert = UIAlertController()
    
    
    // MARK: - Activity + VisualEffects
    
    let activityIndicator = UIActivityIndicatorView()
    let blure = UIVisualEffectView()
    
    
    // MARK: - Navigation Bar
    
    var closeSceneOutletButton = UIBarButtonItem()
    var changeDateOutletButton = UIBarButtonItem()
    var addNewOutletButton = UIBarButtonItem()
    var cancelOutletButton = UIBarButtonItem()
    var saveOutletButton = UIBarButtonItem()
    var editOutletButton = UIBarButtonItem()
    
    
    // MARK: - System
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    
    // MARK: - Gestures
    
    lazy var directionPan = PanDirectionGestureRecognizer(direction: .horizontal,
                                                          target: self,
                                                          action: #selector(didPan(_:)))
    
    // MARK: - UIAlert
    
    //TODO: - Исправить! + Перенести в Extension?
    private func setupAlert() {
        alert = UIAlertController(title: "Ошибка",
                                  message: "",
                                  preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
    }
    
    
    // MARK: - Table view
    
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfLifeCycles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainSceneTableViewCell_BTWW.identifier, for: indexPath) as! MainSceneTableViewCell_BTWW
        cell.label.text = presenter.getCellLabel(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.moveRow(source: sourceIndexPath.row, destination: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.didSelectRow(at: indexPath.row, vc: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard tableView.isEditing else { return false }
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.deleteRow(at: indexPath.row)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue, sourceVC: self)
    }
    
    @IBAction func closeSceneButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDateButton(_ sender: Any) {
        performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction func addNewButton(_ sender: Any) {
        performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    
    // MARK: - Edit mode management
    
    @IBAction func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        presenter.cancelChanges()
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
        presenter.saveChanges()
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    
    deinit {
        // Root VC
    }
    
}

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
                    self.presenter.swipe(gesture: .left)
                } else if newXPosition < negativeXOffset {
                    self.feedbackGenerator.selectionChanged()
                    self.presenter.swipe(gesture: .right)
                } else {
                    return
                }
            })
        default:
            return
        }
    }
    
    // MARK: - Navigation bar
    
    func setupNavBarAppearance() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "Montserrat-Black", size: 34)!]
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: "Montserrat-Regular", size: 17)!]
    }
    
    func setupNavBarButtons() {
        closeSceneOutletButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(closeSceneButton))
        closeSceneOutletButton.tintColor = .label
        changeDateOutletButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(changeDateButton))
        changeDateOutletButton.tintColor = .label
        addNewOutletButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addNewButton))
        addNewOutletButton.tintColor = .label
        cancelOutletButton = UIBarButtonItem (title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
        cancelOutletButton.tintColor = .label
        saveOutletButton = UIBarButtonItem (title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        saveOutletButton.tintColor = .label
        editOutletButton = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(editButton))
        editOutletButton.tintColor = .label
    }
    
    func manageDisplayNavBarButtons() {
        guard activityIndicator.isHidden else { showLoadingModeNavBarButtons(); return }
        switch tableView.isEditing {
        case true:
            showEditModeNavBarButtons()
        case false:
            showNotEditModeNavBarButtons()
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
        navigationItem.rightBarButtonItems = presenter.getNumberOfLifeCycles() != 0 ? [addNewOutletButton, editOutletButton, changeDateOutletButton] : [addNewOutletButton, changeDateOutletButton]
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

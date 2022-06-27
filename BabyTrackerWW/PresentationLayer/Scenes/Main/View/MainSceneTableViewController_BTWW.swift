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
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureScene(view: self)
        setupTableView()
        setupNavBarButtons()
        setupNavBarGestures()
        setupActivityIndicator()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Delete obs
    }
    
    
    // MARK: - Input data flow
    
    private func setupObservers() {
        viewModel.tempLifeCycle.subscribe(observer: self) { [weak self] _ in
            self?.reloadData()
        }
        
        viewModel.isLoading.subscribe(observer: self) { [weak self] isLoading in
            switch isLoading {
            case .true:
                self?.startLoadingMode();
                self?.manageDisplayNavBarButtons();
                self?.manageGestures()
            case .false:
                self?.stopLoadingMode();
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
    
    
    // MARK: - Activity + VisualEffects
    
    let activityIndicator = UIActivityIndicatorView()
    let blure = UIVisualEffectView()
    
    
    // MARK: - Navigation Bar
    
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
        viewModel.deleteRow(at: indexPath.row)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.prepare(for: segue, sourceVC: self)
    }
    
    
    // MARK: - Navigation bar buttons
    
    @IBAction func changeDateButton(_ sender: Any) {
        performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction func addNewButton(_ sender: Any) {
        performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        viewModel.cancelChanges()
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
        viewModel.saveChanges()
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        manageDisplayNavBarButtons()
        manageGestures()
    }
    
    
    // MARK: - UIAlert
    
    private func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    deinit {
        // Root VC
    }
    
}

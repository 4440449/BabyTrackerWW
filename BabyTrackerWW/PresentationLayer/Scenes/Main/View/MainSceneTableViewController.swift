//
//  MainSceneTableViewController.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class MainSceneTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Dependencies
    
    private let configurator = MainSceneConfiguratorImpl()
    var presenter: MainScenePresenterProtocol!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureScene(view: self)
        tableView.tableFooterView = UIView(frame: .zero)
        setupNavBarButtons()
        setupSwipeGestures()
        setupBlure()
        setupActivityIndicator()
        setObservers()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        //Set obs
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Delete obs
    }
    
    
    // MARK: - Private
    
    private func setObservers() {
        presenter.tempLifeCycle.subscribe(observer: self) { [unowned self] _ in
            print("reload data Main")
            self.reloadData()
        }
        presenter.isLoading.subscribe(observer: self) { [unowned self] isLoading in
            switch isLoading {
            case .true:
                self.startActivity();
                self.manageDisplayNavBarButtons();
                self.manageSwipeGestures()
            case .false:
                self.stopActivity();
                self.manageDisplayNavBarButtons();
                self.manageSwipeGestures()
            }
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
        navigationController?.navigationBar.topItem?.title = presenter.getDate()
//        manageDisplayNavBarButtons() // проверить нужен ли здесь вызов метода?
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
    
    // MARK: - Gestures
    
    private lazy var left: UISwipeGestureRecognizer = {
        let gest = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        gest.direction = .left
        return gest
    }()
    private lazy var right: UISwipeGestureRecognizer = {
        let gest = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        gest.direction = .right
        return gest
    }()
    
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print(presenter.getNumberOfLifeCycles())
        return presenter.getNumberOfLifeCycles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSceneCell", for: indexPath) as! MainSceneTableViewCell
        cell.label.text = presenter.getCellLabel(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //        print("source index == \(sourceIndexPath.row),,, destination index == \(destinationIndexPath.row)")
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
        presenter.prepare(for: segue, parentVC: self)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    deinit {
        // Root VC
    }
    
}

// MARK: - Internal setup - Behaviours -

extension MainSceneTableViewController {
    
    // MARK: - Gestures
    
    private func setupSwipeGestures() {
        tableView.addGestureRecognizer(left)
        tableView.addGestureRecognizer(right)
        print(left)
        print(right)
    }
    
    private func manageSwipeGestures() {
        if (!tableView.isEditing && activityIndicator.isHidden) {
            enableSwipeGestures()
        } else {
            disableSwipeGestures()
        }
    }
    
    private func enableSwipeGestures() {
        tableView.gestureRecognizers?.forEach {
            if ($0 == left || $0 == right) {
                $0.isEnabled = true
            }
        }
    }
    
    private func disableSwipeGestures() {
        tableView.gestureRecognizers?.forEach {
            if ($0 == left || $0 == right) {
                $0.isEnabled = false
            }
        }
    }
    
    @objc private func leftSwipe() {
        print("left")
        presenter.swipe(gesture: .left)
    }
    
    @objc private func rightSwipe() {
        print("right")
        presenter.swipe(gesture: .right)
    }
    
    
    // MARK: - Navigation bar
    
    private func setupNavBarButtons() {
        changeDateOutletButton = UIBarButtonItem(title: "Изменить дату", style: .plain, target: self, action: #selector(changeDateButton))
        addNewOutletButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addNewButton))
        cancelOutletButton = UIBarButtonItem (title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
        saveOutletButton = UIBarButtonItem (title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        editOutletButton = UIBarButtonItem (title: "Редактировать", style: .plain, target: self, action: #selector(editButton))
    }
    
    private func manageDisplayNavBarButtons() {
        guard activityIndicator.isHidden else { showLoadingStateNavBarButtons(); return }
        switch tableView.isEditing {
        case true: hideNavBarButtons()
        case false: showNavBarButtons()
        }
    }
    
    private func hideNavBarButtons() {
        navigationItem.leftBarButtonItems = [cancelOutletButton]
        navigationItem.rightBarButtonItems = [saveOutletButton]
    }
    
    private func showNavBarButtons() {
        navigationItem.leftBarButtonItems = [changeDateOutletButton]
        navigationItem.rightBarButtonItems = presenter.getNumberOfLifeCycles() != 0 ? [addNewOutletButton, editOutletButton] : [addNewOutletButton]
    }
    
    private func showLoadingStateNavBarButtons() {
        navigationItem.leftBarButtonItems = [changeDateOutletButton]
        navigationItem.rightBarButtonItems = [addNewOutletButton]
    }
    
    
    @IBAction private func changeDateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction private func addNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
        
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        manageSwipeGestures()
        presenter.cancelChanges()
    }
    
    @IBAction private func saveButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        manageSwipeGestures()
        presenter.saveChanges()
    }
    
    @IBAction private func editButton(_ sender: Any) {
        tableView.setEditing(true, animated: true)
        manageDisplayNavBarButtons()
        manageSwipeGestures()
    }
    
    
    // MARK: - Activity indicator
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
    }
    
    private func startActivity() {
        showBlure()
        activityIndicator.startAnimating()
        //        self.tableView.numberOfRows(inSection: 0)
        //        self.tableView.reloadData()
        //        view.isOpaque = false
        //        self.tableView.isOpaque = false
        //        self.tableView.isUserInteractionEnabled = false
    }
    
    private func stopActivity() {
        hideBlure()
        activityIndicator.stopAnimating()
        //        self.tableView.isOpaque = true
        //        self.tableView.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Blure effect
    
    private func setupBlure() {
        let style: UIBlurEffect.Style = self.traitCollection.userInterfaceStyle == .dark ?
            .systemThinMaterialDark : .systemThinMaterialLight
        let blurEffect = UIBlurEffect(style: style)
        blure.effect = blurEffect
        blure.frame = view.bounds
        blure.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blure)
    }
    
    private func showBlure() {
        blure.isHidden = false
    }
    
    private func hideBlure() {
        blure.isHidden = true
    }
    
}





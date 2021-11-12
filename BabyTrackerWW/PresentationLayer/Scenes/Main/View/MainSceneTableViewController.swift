//
//  MainSceneTableViewController.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class MainSceneTableViewController: UITableViewController {
    
    // MARK: - Dependencies
    
    private let configurator = MainSceneConfiguratorImpl()
    var presenter: MainScenePresenterProtocol!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configureScene(view: self)
//        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        setNavBarButtons()
        setActivityIndicator()
        setObservers()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        reloadData()
//        showNavBarButtons()
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
            case .true: self.startActivity()
            case .false: self.stopActivity()
            }
        }
    }
    
    private func reloadData() {
           tableView.reloadData()
//        navigationController?.navigationBar.topItem?. = UIBarButtonItem(title: presenter.getDate(), style: .plain, target: self, action: #selector(changeDateButton))
        
           navigationController?.navigationBar.topItem?.title = presenter.getDate()
            manageDisplayNavBarButtons()
       }
    
    
    // MARK: - Activity
    
    private let activityIndicator = UIActivityIndicatorView()
    
    
    // MARK: - Navigation Bar
    
    private var changeDateOutletButton: UIBarButtonItem!
    private var addNewOutletButton: UIBarButtonItem!
    private var cancelOutletButton: UIBarButtonItem!
    private var saveOutletButton: UIBarButtonItem!
    private var editOutletButton: UIBarButtonItem!
    
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(presenter.getNumberOfLifeCycles())
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
            presenter.didSelectRow(at: indexPath.row) { identifire in
                self.performSegue(withIdentifier: identifire, sender: nil)
            }
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
        presenter.prepare(for: segue)
    }
    
    deinit {
        // Root VC
    }
    
}


extension MainSceneTableViewController {
    
    private func setNavBarButtons() {
        changeDateOutletButton = UIBarButtonItem(title: "Изменить дату", style: .plain, target: self, action: #selector(changeDateButton))
        addNewOutletButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addNewButton))
        cancelOutletButton = UIBarButtonItem (title: "Отменить", style: .plain, target: self, action: #selector(cancelButton))
        saveOutletButton = UIBarButtonItem (title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        editOutletButton = UIBarButtonItem (title: "Редактировать", style: .plain, target: self, action: #selector(editButton))
    }
    
    
    private func manageDisplayNavBarButtons() {
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
    
    
    
    @IBAction private func changeDateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction private func addNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        //showNavBarButtons()
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        presenter.cancelChanges()
//        tableView.reloadData() //
    }
    
    @IBAction private func saveButton(_ sender: Any) {
//        showNavBarButtons()
        tableView.setEditing(false, animated: true)
        manageDisplayNavBarButtons()
        presenter.saveChanges()
    }
    
    @IBAction private func editButton(_ sender: Any) {
//        hideNavBarButtons()
        tableView.setEditing(true, animated: true)
        manageDisplayNavBarButtons()
    }
    
}


extension MainSceneTableViewController {
    
    private func setActivityIndicator() {
        activityIndicator.center = tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
    }
    
    private func startActivity() {
//        self.tableView.numberOfRows(inSection: 0)
//        self.tableView.reloadData()
//        view.isOpaque = false
        activityIndicator.startAnimating()
//        self.tableView.isOpaque = false
//        self.tableView.isUserInteractionEnabled = false
    }
    
    private func stopActivity() {
        activityIndicator.stopAnimating()
//        self.tableView.isOpaque = true
//        self.tableView.isUserInteractionEnabled = true
    }
    
}




//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "Удалить"
//    }


//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//
//    }

//    override func setEditing(_ editing: Bool, animated: Bool) {
////        super.setEditing(editing, animated: animated)
////        tableView.setEditing(editing, animated: true)
//    }

//    func setButton() {
//        var button = UIButton(type: .system)
//        button.frame = CGRect(x: 250, y: 450 , width: 100, height: 100)
//        button.backgroundColor = .green
////        button.addTarget(self, action: #selector(saveButton), for: .touchUpInside)
//        view.addSubview(button)
//    }

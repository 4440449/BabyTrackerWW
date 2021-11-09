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
        tableView.tableFooterView = UIView(frame: .zero)
        setNavBarButtons()
        setActivityIndicator()
        presenter.observeCardState(self) { [unowned self] in self.reloadData() }
        presenter.observeActivityState(self) { [unowned self] isLoading in
            switch isLoading {
            case .true: self.startActivity()
            case .false: self.stopActivity()
            }
        }
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
    
    private func reloadData() {
        tableView.reloadData()
        navigationController?.navigationBar.topItem?.title = presenter.getDate()
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
        return presenter.getNumberOfLifeCycles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSceneCell", for: indexPath) as! MainSceneTableViewCell
        cell.label.text = presenter.getCellLabel(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("source index == \(sourceIndexPath.row),,, destination index == \(destinationIndexPath.row)")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        presenter.deleteRow(at: indexPath.row)
        print("delete")
//        tableView.reloadData()
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
        
        showNavBarButtons()
    }
    
    private func hideNavBarButtons() {
        self.navigationItem.leftBarButtonItems = [cancelOutletButton]
        self.navigationItem.rightBarButtonItems = [saveOutletButton]
        
    }
    
    private func showNavBarButtons() {
        self.navigationItem.leftBarButtonItems = [changeDateOutletButton]
        self.navigationItem.rightBarButtonItems = [addNewOutletButton, editOutletButton]
    }
    
    
    @IBAction private func changeDateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction private func addNewButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        showNavBarButtons()
        tableView.setEditing(false, animated: true)
        tableView.reloadData() //
    }
    
    @IBAction private func saveButton(_ sender: Any) {
        showNavBarButtons()
        tableView.setEditing(false, animated: true)
        presenter.saveChanges()
    }
    
    @IBAction private func editButton(_ sender: Any) {
        hideNavBarButtons()
        tableView.setEditing(true, animated: true)
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
        activityIndicator.startAnimating()
    }
    
    private func stopActivity() {
        activityIndicator.stopAnimating()
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

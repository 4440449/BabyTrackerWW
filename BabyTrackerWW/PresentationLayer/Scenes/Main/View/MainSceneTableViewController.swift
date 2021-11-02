//
//  MainSceneTableViewController.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class MainSceneTableViewController: UITableViewController {
    
    private let configurator = MainSceneConfiguratorImpl()
    var presenter: MainScenePresenterProtocol!
    
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configureScene(view: self)
        presenter.addObserver { [unowned self] in self.reloadData() } // сделать полноценный обзервер
        tableView.tableFooterView = UIView(frame: .zero) // скрываю пустые ячейки
        setupActivityIndicator()
        reloadData()
        presenter.observeActivity { [unowned self] isLoading in
            switch isLoading {
            case .loading: self.startActivity()
            case .notLoading: self.stopActivity()
            }
        }
        presenter.viewDidLoad()
    }
    
    func reloadData() {
        tableView.reloadData()
        navigationController?.navigationBar.topItem?.title = presenter.dateOfCard
    }
    
    @IBAction func changeDateButton(_ sender: Any) {
        //        presenter.changeDateAction()
        self.performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction func addNewDreamButton(_ sender: Any) {
        presenter.addNewDreamButtonTapped()
        self.performSegue(withIdentifier: "addNewLifeCycleAction", sender: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
       tableView.setEditing(true, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        presenter.saveChanges()
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
//        editButton(self)
//        editButtonItem.accessibilityElementsHidden = true
    }
    
    
    
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfDreams
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSceneCell", for: indexPath) as! MainSceneTableViewCell
        cell.label.text = presenter.setCellLabel(at: indexPath.row)
        //        cell.isEditing = self.tableView(tableView, canMoveRowAt: indexPath)
        
        return cell
    }
    
    
    //    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("source index == \(sourceIndexPath.row),,, destination index == \(destinationIndexPath.row)")
        presenter.moveRow(source: sourceIndexPath.row, destination: destinationIndexPath.row)
    }
    
    
    // MARK: - Table view delegate -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.didSelectRow(at: indexPath.row) { identifire in
                self.performSegue(withIdentifier: identifire, sender: nil) }
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        //Роутер должен дергать сегвей в зависимости от типа объекта
    }
  
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: - Нет анимации удаления ячейки, сейчас она просто дергается.
//        tableView.deleteRows(at: [indexPath], with: .fade)
        presenter.deleteRow(at: indexPath.row)
//        tableView.setEditing(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Navigation -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue)
    }
    //    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    //    }
    
    
    
    deinit {
        // на данный момент деинита мейн сцены не будет тк это рутовый контроллер, так что удалять обзерверы не надо
    }
}


extension MainSceneTableViewController {
    
    private func setupActivityIndicator() {
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
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

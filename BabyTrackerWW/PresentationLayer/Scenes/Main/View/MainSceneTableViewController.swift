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
        tableView.tableFooterView = UIView(frame: .zero)
        setupActivityIndicator()
        presenter.observeCardState(self) { [unowned self] in self.reloadData() }
        presenter.observeActivityState(self) { [unowned self] isLoading in
            switch isLoading {
            case .true: self.startActivity()
            case .false: self.stopActivity()
            }
        }
        presenter.viewDidLoad()
        setButton()
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
    
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    func reloadData() {
        tableView.reloadData()
        navigationController?.navigationBar.topItem?.title = presenter.getDate()
    }
    
    @IBAction func changeDateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "changeDateButton", sender: nil)
    }
    
    @IBAction func addNewLifeCycleButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addNewLifeCycleButton", sender: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print("save")
        //        presenter.saveChanges()
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        //        editButton(self)
        //        editButtonItem.accessibilityElementsHidden = true
    }
    
    
    
    
    // MARK: - Table view data source -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfLifeCycles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSceneCell", for: indexPath) as! MainSceneTableViewCell
        cell.label.text = presenter.getCellLabel(at: indexPath.row)
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
                self.performSegue(withIdentifier: identifire, sender: nil)
            }
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
    
    

    
    
    deinit {
        // на данный момент деинита мейн сцены не будет тк это рутовый контроллер, так что удалять обзерверы не надо
    }
    
    func setButton() {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 250, y: 450 , width: 100, height: 100)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(saveButton), for: .touchUpInside)
        view.addSubview(button)
    }
}


extension MainSceneTableViewController {
    
    private func setupActivityIndicator() {
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

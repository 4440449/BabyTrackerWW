//
//  SelectViewController.swift
//  BabyTrackerWW
//
//  Created by Max on 15.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - State
    
    private let typeDescriptions = ["Сон", "Бодрствование"]
    var segueCallback: ((Int) -> ())!
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupTableView()
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var foregroundTableView: UITableView!
    
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSceneCell", for: indexPath) as! SelectSceneTableViewCell
        cell.label.text = typeDescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: presentingViewController?.dismiss(animated: false, completion: nil);
        segueCallback(0)
        case 1: presentingViewController?.dismiss(animated: false, completion: nil);
        segueCallback(1)
        default: print("Error! SelectSceneTableViewController.didSelectRowAt \\ Invalid index -- \(indexPath.row)")
        }
    }
    
}



// MARK: - Internal setup -

extension SelectViewController {
    
    private func setupBackgroundView() {
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 20, height: -20)
        backgroundView.layer.shadowRadius = 130
        backgroundView.layer.shadowOpacity = 0.5
    }
    
    private func setupTableView() {
        foregroundTableView.delegate = self
        foregroundTableView.dataSource = self
        
        foregroundTableView.tableFooterView = UIView(frame: .zero)
        foregroundTableView.layer.cornerRadius = 13
    }
}

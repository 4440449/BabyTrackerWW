//
//  SelectSceneTableViewController.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit

class SelectSceneTableViewController: UITableViewController {
    
//    let configurator = SelectSceneConfiguratorImpl()
//    var presenter: SelectScenePresenterProtocol!
    
    private let typeDescriptions = ["Сон", "Бодрствование"]
    var segueCallback: ((Int) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopoverSettings()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        //        print("viewWillAppear")
    //    }
    //    override func viewDidAppear(_ animated: Bool) {
    //        //        print("viewDidAppear")
    //    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        //        print("viewWillDisappear")
    //    }
    //    override func viewDidDisappear(_ animated: Bool) {
    //        //        print("viewDidDisappear")
    //    }
    
    // MARK: - UI
    
    //    private let animation = UIDynamicAnimator()
    private func setupPopoverSettings() {
        preferredContentSize = CGSize(width: 250, height: 87)
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverPresentationController?.popoverLayoutMargins = UIEdgeInsets(top: 40, left: 160, bottom: 0, right: 20)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSceneCell", for: indexPath) as! SelectSceneTableViewCell
        cell.label.text = typeDescriptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: presentingViewController?.dismiss(animated: false, completion: nil);
                segueCallback(0)
        case 1: presentingViewController?.dismiss(animated: false, completion: nil);
                segueCallback(1)
        default: print("Error! SelectSceneTableViewController.didSelectRowAt \\ Invalid index -- \(indexPath.row)")
        }
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        presenter.prepare(for: segue)
    ////        parent?.dismiss(animated: true, completion: nil)
    //    }
    
    
    deinit {
        //           print("SelectSceneTableViewController - is Deinit!")
    }
    
}




//extension SelectSceneTableViewController: UIViewControllerTransitioningDelegate {
//
//}

//
//  SelectSceneTableViewController.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit

class SelectSceneTableViewController: UITableViewController {
    
    let configurator = SelectSceneConfiguratorImpl()
    var presenter: SelectScenePresenterProtocol!
    
    private let typeDescriptions = ["Бодрствование", "Сон"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
//        print("viewDidAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
//        print("viewWillDisappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
//        print("viewDidDisappear")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            case 0: self.performSegue(withIdentifier: "addNewWakeAction", sender: nil)
            case 1: self.performSegue(withIdentifier: "addNewDreamAction", sender: nil)
            default: print("Error! SelectSceneTableViewController.didSelectRowAt indexPath()")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          presenter.prepare(for: segue)
      }
    
//        override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    deinit {
           print("SelectSceneTableViewController - is Deinit!")
       }

}

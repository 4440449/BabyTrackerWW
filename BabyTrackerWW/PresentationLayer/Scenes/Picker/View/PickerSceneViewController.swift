//
//  PickerSceneViewController.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var presenter: PickerScenePresenterProtocol!
    var configurator = PickerSceneConfiguratorImpl()
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView(picker, didSelectRow: 0, inComponent: 0)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        presenter.saveButtonCliked()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.numberOfRowsInComponent()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.titleForRow(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.didSelectRow(row: row)
    }
    
    deinit {
//        print ("PickerViewController - is Deinit!")
    }
    
}

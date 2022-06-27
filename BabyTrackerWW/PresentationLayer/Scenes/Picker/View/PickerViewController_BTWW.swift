//
//  PickerViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class PickerViewController_BTWW: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var viewModel: PickerSceneViewModelProtocol_BTWW!
    var configurator = PickerSceneConfigurator_BTWW()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView(picker, didSelectRow: 0, inComponent: 0)
        saveButton.layer.cornerRadius = 5
    }
    
    @IBAction func saveButton(_ sender: Any) {
        viewModel.saveButtonCliked()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectRow(row: row)
    }
    
    deinit {
//        print ("PickerViewController - is Deinit!")
    }
    
}

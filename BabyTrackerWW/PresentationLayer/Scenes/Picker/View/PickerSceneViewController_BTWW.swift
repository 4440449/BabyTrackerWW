//
//  PickerViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class PickerSceneViewController_BTWW: UIViewController,
                                            UIPickerViewDataSource,
                                            UIPickerViewDelegate {
    
    // MARK: - Dependencies
    
    let configurator = PickerSceneConfigurator_BTWW()
    private var presenter: PickerScenePresenterInputProtocol_BTWW!
    
    func setupPresenter(_ presenter: PickerScenePresenterInputProtocol_BTWW) {
        self.presenter = presenter
    }
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutletButtons()
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButton(_ sender: Any) {
        presenter.saveButtonCliked()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupOutletButtons() {
        saveButton.layer.cornerRadius = 5
        saveButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)!
    }
    
//    private func setupPicker() {
//        picker.font
//    }
    
    //PickerView
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

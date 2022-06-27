//
//  CalendarSceneViewController_BTWW.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit

//TODO: - Не хватает кнопки "Сегодня"

final class CalendarSceneViewController_BTWW: UIViewController {
    
    var configurator = CalendarSceneConfigurator_BTWW()
    var viewModel: CalendarSceneViewModelProtocol_BTWW!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
//        datePicker.locale = Locale(identifier: "ru_RU")
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .compact
//        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.date = viewModel.getCurrentDate()
        dateLabel.text = viewModel.format(date:datePicker.date)
        
        saveButton.layer.cornerRadius = 5
    }
    
    @objc func dateChanged() {
        dateLabel.text = viewModel.format(date:datePicker.date)
        viewModel.dateSelected(new: datePicker.date)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        viewModel.saveButtonTapped()
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

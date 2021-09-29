//
//  CalendarSceneViewController.swift
//  Baby tracker
//
//  Created by Max on 10.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit

final class CalendarSceneViewController: UIViewController {
    
    var configurator = CalendarSceneConfiguratorImpl()
    var presenter: CalendarScenePresenterProtocol!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.date = presenter.currentDate
        dateLabel.text = presenter.format(date:datePicker.date)

    }
    
    @objc func dateChanged() {
        dateLabel.text = presenter.format(date:datePicker.date)
        presenter.dateSelected(new: datePicker.date)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        presenter.saveButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
}

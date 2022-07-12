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
    
    // MARK: - Dependencies
    
    let configurator = CalendarSceneConfigurator_BTWW()
    private var presenter: CalendarScenePresenterInputProtocol_BTWW!
    
    func setupPresenter(_ presenter: CalendarScenePresenterInputProtocol_BTWW) {
        self.presenter = presenter
    }
    
    
    // MARK: - Lifecycle View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        saveButton.layer.cornerRadius = 5
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private func setupDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.date = presenter.getCurrentDate()
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

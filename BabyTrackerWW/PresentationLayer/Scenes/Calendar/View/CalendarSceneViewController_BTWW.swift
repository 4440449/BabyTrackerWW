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
        setupLabels()
        setupOutletButtons()
    }
    
    
    // MARK: - UI
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private func setupLabels() {
        dateLabel.text = presenter.format(date:datePicker.date)
        dateLabel.font = UIFont(name: "Montserrat-Bold", size: 24)!
    }
    
    private func setupDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.date = presenter.getCurrentDate()
    }
    
    private func setupOutletButtons() {
        saveButton.layer.cornerRadius = 5
        saveButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)!
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

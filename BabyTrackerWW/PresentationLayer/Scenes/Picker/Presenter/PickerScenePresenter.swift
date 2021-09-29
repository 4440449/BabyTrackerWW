//
//  PickerScenePresenter.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


protocol PickerScenePresenterProtocol {
    
    func numberOfRowsInComponent() -> Int
    func titleForRow(row: Int) -> String
    func didSelectRow(row: Int)
    func saveButtonCliked()
}

//protocol DetailSceneDelegateProtocol {
//    associatedtype T = DreamProperty
//    var callback: (T) -> () { get set }
//}

//MARK: - Implementation -

final class PickerScenePresenterImpl<T: CaseIterable & RawRepresentable & LifeCycleProperty>: PickerScenePresenterProtocol /*, DetailSceneDelegateProtocol */ {
    
    private let lifeCyclePropertyRequest: T.Type
    private var lifeCyclePropertyResponse: T!
    private let callback: (T) -> ()
    
    init(lifeCyclePropertyType: T.Type, callback: @escaping (T) -> ()) {
        self.lifeCyclePropertyRequest = lifeCyclePropertyType.self
        self.callback = callback
    }
    
    func numberOfRowsInComponent() -> Int {
        numberOfRows(value: lifeCyclePropertyRequest.self)
    }
    
    func titleForRow(row: Int) -> String {
        titleRow(value: lifeCyclePropertyRequest.self, row: row)
    }
    
    func didSelectRow(row: Int) {
        didSelect(value: lifeCyclePropertyRequest.self, row: row)
    }
    
    func saveButtonCliked() {
        callback(lifeCyclePropertyResponse)
    }
    
    func numberOfRows(value: T.Type) -> Int {
        return value.allCases.count
    }
    
    func titleRow(value: T.Type, row: Int) -> String {
        let rowTitle = value.allCases.map { $0.rawValue } [row]
        return rowTitle as! String
    }
    
    func didSelect(value: T.Type, row: Int) {
        let rowTitle = value.allCases.map { $0 } [row]
        lifeCyclePropertyResponse = rowTitle
    }
    
    deinit {
//        print("PickerPresenter - is Deinit!")
    }
    
}

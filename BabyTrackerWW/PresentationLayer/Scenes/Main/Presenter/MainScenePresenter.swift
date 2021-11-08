//
//  MainScenePresenter.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol MainScenePresenterProtocol {
    
    func viewDidLoad()
    func observeCardState(_ observer: AnyObject, _ callback: @escaping () -> ())
    func observeActivityState(_ observer: AnyObject, _ callback: @escaping (Loading) -> ())
    func getDate() -> String
    func getNumberOfLifeCycles() -> Int
    func getCellLabel(at index: Int) -> String
    
    func didSelectRow(at index: Int, callback: (String) -> ())
    func prepare<T>(for segue: T)
    func deleteRow(at index: Int)
    func moveRow(source: Int, destination: Int)
    func saveButtonTapped()
}

//MARK: - Implementation -

final class MainScenePresenterImpl: MainScenePresenterProtocol {
    
    
    //MARK: - Dependencies
    
    private let router: MainSceneRouterProtocol
    private let interactor: MainSceneDelegate
    
    init (router: MainSceneRouterProtocol, interactor: MainSceneDelegate) {
        self.router = router
        self.interactor = interactor
    }
    
    
    //MARK: - State
    
    private var tempLifeCycle: [LifeCycle] = [] {
        didSet { print("tempLC ==========++++========== \(self.tempLifeCycle)") }
    }
    
    
      // MARK: - View Input
    
    func viewDidLoad() {
        interactor.fetchLifeCycles()
        //        interactor.LCobserve { [unowned self] lc in // 31.10.21 -- test
        //            self.tempLifeCycle = lc
        //        }
    }
    
    func observeCardState(_ observer: AnyObject, _ callback: @escaping () -> ()) {
        interactor.subscribeToCardState(observer, callback)
    }
    
    func observeActivityState(_ observer: AnyObject, _ callback: @escaping (Loading) -> ()) {
        interactor.subscribeToLoadingState(observer, callback)
    }
    

    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter.string(from: interactor.shareStateForMainScene().date)
    }
    
    func getNumberOfLifeCycles() -> Int {
        return interactor.shareStateForMainScene().lifeCycle.count
    }
    
    func getCellLabel(at index: Int) -> String {
        return interactor.shareStateForMainScene().lifeCycle[index].title
    }
    
    
    //MARK: - View Output
    
    func didSelectRow(at index: Int, callback: (String) -> ()) {
        let type = interactor.shareStateForMainScene().lifeCycle[index]
        router.perform(type: type, callback: callback)
    }
    
    func prepare<T>(for segue: T) {
        router.prepare(for: segue, delegate: interactor)
    }
    
    func deleteRow(at index: Int) {
        //        tempLifeCycle.remove(at: index)
        interactor.deleteLifeCycle(at: index)
    }
    
    func moveRow(source: Int, destination: Int) {
        tempLifeCycle.forEach { print("До изменения \($0.index) \($0.id)") }
        tempLifeCycle.rearrange(from: source, to: destination)
        tempLifeCycle.forEach { print("После изменения \($0.index) \($0.id)") }
        //        print("tempLifeCycle.count == \(tempLifeCycle.count)")
        for i in 0..<tempLifeCycle.count {
            //            print("i == \(i)")
            tempLifeCycle[i].index = i
            //            print("tempLifeCycle[i].index == \(tempLifeCycle[i].index)")
        }
        tempLifeCycle.forEach { print("После цикла \($0.index) \($0.id)") }
    }
    
    func saveButtonTapped() {
        interactor.reindex(new: tempLifeCycle)
    }
    
}



extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

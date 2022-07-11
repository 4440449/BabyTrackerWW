//
//  MainScenePresenter_BTWW.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol MainScenePresenterOutputPrtotocol_BTWW: AnyObject {
    func reloadData()
    func newLoadingState(_ isLoading: Bool)
    func newError(_ message: String)
}

protocol MainScenePresenterInputProtocol {
    func viewDidLoad()
    func getDate() -> String
    func getNumberOfLifeCycles() -> Int
    func getCellLabel(at index: Int) -> String
    func didSelectRow<V>(at index: Int, vc: V)
    func prepare<T,V>(for segue: T, sourceVC: V)
    func deleteRow(at index: Int)
    func moveRow(source: Int, destination: Int)
    func saveChanges()
    func cancelChanges()
    func swipe(gesture: Swipe)
}


//MARK: - Implementation -

final class MainScenePresenter_BTWW: MainScenePresenterInputProtocol {
    
    //MARK: - Dependencies
    
    private unowned var view: MainScenePresenterOutputPrtotocol_BTWW
    private let router: MainSceneRouterProtocol_BTWW
    private let interactor: MainSceneDelegate_BTWW
    
    init(view: MainScenePresenterOutputPrtotocol_BTWW,
         router: MainSceneRouterProtocol_BTWW,
         interactor: MainSceneDelegate_BTWW) {
        self.view = view
        self.router = router
        self.interactor = interactor
        setObservers()
    }
    
    
    //MARK: - Buffer
    
    private var lifeCycles = [LifeCycle]() {
        didSet {
            self.view.reloadData()
        }
    }
    
    
    //MARK: - Private
    
    private func setObservers() {
        interactor.lifeCycleCard.subscribe(observer: self) { [weak self] card in
            self?.lifeCycles = card.lifeCycle
        }
        interactor.isLoading.subscribe(observer: self) { [weak self] isLoading in
            self?.view.newLoadingState(isLoading)
        }
        interactor.error.subscribe(observer: self) { [weak self] error in
            self?.view.newError(error)
        }
    }
    
    private func removeObservers() {
        interactor.lifeCycleCard.unsubscribe(observer: self)
        interactor.isLoading.unsubscribe(observer: self)
    }
    
    
    // MARK: - Input interface
    
    func viewDidLoad() {
        interactor.fetchLifeCycles(at: interactor.shareStateForMainScene().date)
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter.string(from: interactor.shareStateForMainScene().date)
    }
    
    func getNumberOfLifeCycles() -> Int {
        return lifeCycles.count
    }
    
    func getCellLabel(at index: Int) -> String {
        return lifeCycles[index].title
    }
    
    
    func didSelectRow<V>(at index: Int, vc: V) {
        let type = interactor.shareStateForMainScene().lifeCycle[index]
        router.perform(type: type, vc: vc)
    }
    
    func prepare<T,V>(for segue: T, sourceVC: V) {
        router.prepare(for: segue, delegate: interactor, sourceVC: sourceVC)
    }
    
    
    func deleteRow(at index: Int) {
        lifeCycles.remove(at: index)
    }
    
    func moveRow(source: Int, destination: Int) {
        var lc = lifeCycles
        lc.rearrange(from: source, to: destination)
        for i in 0..<lc.count {
            lc[i].index = i
        }
        lifeCycles = lc
    }
    
    func cancelChanges() {
        lifeCycles = interactor.shareStateForMainScene().lifeCycle
    }
    
    func saveChanges() {
        for i in 0..<(lifeCycles.count != 0 ? lifeCycles.count : 1) {
            if lifeCycles.count != interactor.lifeCycleCard.value.lifeCycle.count || lifeCycles[i].id != interactor.lifeCycleCard.value.lifeCycle[i].id {
                interactor.synchronize(newValue: lifeCycles)
                return
            }
        }
    }
    
    func swipe(gesture: Swipe) {
        switch gesture {
        case .left:
            guard let previousDay = interactor.shareStateForMainScene().date.previousDay() else {
                print("Error fetch date")
                return
            }
            interactor.fetchLifeCycles(at: previousDay)
            
        case .right:
            guard let nextDay = interactor.shareStateForMainScene().date.nextDay() else {
                print("Error fetch date")
                return
            }
            interactor.fetchLifeCycles(at: nextDay)
        }
    }
    
    
    deinit {
        removeObservers()
    }
    
    
}

//TODO: - перенести!
//MARK: - Extensions

extension Array {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension Date {
    
    func nextDay() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let nextDay = calendar.date(byAdding: .hour, value: 24, to: self)
        return nextDay
    }
    
    func previousDay() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let previousDay = calendar.date(byAdding: .hour, value: -24, to: self)
        return previousDay
    }
    
    
}

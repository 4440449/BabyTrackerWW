//
//  MainScenePresenter.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol MainScenePresenterProtocol {
    
    var tempLifeCycle: Publisher<[LifeCycle]> { get }
    var isLoading: Publisher<Loading> { get }
    func viewDidLoad()
    func getDate() -> String
    func getNumberOfLifeCycles() -> Int
    func getCellLabel(at index: Int) -> String
    
    func didSelectRow<V>(at index: Int, vc: V)
    func prepare<T,V>(for segue: T, parentVC: V)
    func deleteRow(at index: Int)
    func moveRow(source: Int, destination: Int)
    func saveChanges()
    func cancelChanges()
    
    func swipe(gesture: Swipe)
}

//MARK: - Implementation -

final class MainScenePresenterImpl: MainScenePresenterProtocol {
    
    
    //MARK: - Dependencies
    
    private let router: MainSceneRouterProtocol
    private let interactor: MainSceneDelegate
    
    init (router: MainSceneRouterProtocol, interactor: MainSceneDelegate) {
        self.router = router
        self.interactor = interactor
        setObservers()
    }
    
    
    //MARK: - State
    
    var tempLifeCycle = Publisher(value: [LifeCycle]())
    var isLoading = Publisher(value: Loading.false)
    var error = Publisher(value: "")
    
    
    //MARK: - Private
    
    private func setObservers() {
        interactor.lifeCycleCard.subscribe(observer: self) { [unowned self] card in
            self.tempLifeCycle.value = card.lifeCycle
        }
        interactor.isLoading.subscribe(observer: self) { [unowned self] isLoading in
            self.isLoading.value = isLoading
        }
    }
    
    private func removeObservers() {
        interactor.lifeCycleCard.unsubscribe(observer: self)
        interactor.isLoading.unsubscribe(observer: self)
    }
    
    
    // MARK: - View Input
    
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
        return tempLifeCycle.value.count
    }
    
    func getCellLabel(at index: Int) -> String {
        return tempLifeCycle.value[index].title
    }
    
    
    //MARK: - View Output
    
    func didSelectRow<V>(at index: Int, vc: V) {
        let type = interactor.shareStateForMainScene().lifeCycle[index]
        router.perform(type: type, vc: vc)
    }
    
    func prepare<T,V>(for segue: T, parentVC: V) {
        router.prepare(for: segue, delegate: interactor, parentVC: parentVC)
    }
    
    
    func deleteRow(at index: Int) {
        tempLifeCycle.value.remove(at: index)
    }
    
    func moveRow(source: Int, destination: Int) {
        var lc = tempLifeCycle.value
        lc.rearrange(from: source, to: destination)
        for i in 0..<lc.count {
            lc[i].index = i
        }
        tempLifeCycle.value = lc
    }
    
    func cancelChanges() {
        tempLifeCycle.value = interactor.shareStateForMainScene().lifeCycle
    }
    
    func saveChanges() {
        for i in 0..<(tempLifeCycle.value.count != 0 ? tempLifeCycle.value.count : 1) {
            if tempLifeCycle.value.count != interactor.lifeCycleCard.value.lifeCycle.count || tempLifeCycle.value[i].id != interactor.lifeCycleCard.value.lifeCycle[i].id {
                interactor.synchronize(newValue: tempLifeCycle.value)
                return
            }
        }
    }
    
    func swipe(gesture: Swipe) {
        switch gesture {
        case .left:
            guard let dayAfter = interactor.shareStateForMainScene().date.after() else { print("Error fetch date"); return }
            interactor.fetchLifeCycles(at: dayAfter)
            
        case .right:
            guard let dayBefore = interactor.shareStateForMainScene().date.before() else { print("Error fetch date"); return }
            interactor.fetchLifeCycles(at: dayBefore)
        }
    }
    
    
    deinit {
        removeObservers()
    }
    
    
}

//MARK: - Extensions

extension Array {
    
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

extension Date {
    
    func after() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let dayAfter = calendar.date(byAdding: .hour, value: 24, to: self)
        return dayAfter
    }
    
    func before() -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let dayBefore = calendar.date(byAdding: .hour, value: -24, to: self)
        return dayBefore
    }
    
    
}

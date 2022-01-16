//
//  MainSceneViewModel_BTWW.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import MommysEye


protocol MainSceneViewModelProtocol_BTWW {
    
    var tempLifeCycle: Publisher<[LifeCycle]> { get }
    var isLoading: Publisher<Loading> { get }
    var error: Publisher<String> { get }
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

final class MainSceneViewModel_BTWW: MainSceneViewModelProtocol_BTWW {
    
    
    //MARK: - Dependencies
    
    private let router: MainSceneRouterProtocol_BTWW
    private let interactor: MainSceneDelegate_BTWW
    
    init (router: MainSceneRouterProtocol_BTWW, interactor: MainSceneDelegate_BTWW) {
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
        interactor.lifeCycleCard.subscribe(observer: self) { [weak self] card in
            self?.tempLifeCycle.value = card.lifeCycle
        }
        interactor.isLoading.subscribe(observer: self) { [weak self] isLoading in
            self?.isLoading.value = isLoading
        }
        interactor.error.subscribe(observer: self) { [weak self] error in
            self?.error.value = error
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
    
    func prepare<T,V>(for segue: T, sourceVC: V) {
        router.prepare(for: segue, delegate: interactor, sourceVC: sourceVC)
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
            guard let previousDay = interactor.shareStateForMainScene().date.previousDay() else { print("Error fetch date"); return }
            interactor.fetchLifeCycles(at: previousDay)
            
        case .right:
            guard let nextDay = interactor.shareStateForMainScene().date.nextDay() else {
             print("Error fetch date"); return }
            interactor.fetchLifeCycles(at: nextDay)
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

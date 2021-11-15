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
    
    func didSelectRow(at index: Int, callback: (String) -> ())
    func prepare<T>(for segue: T)
    func deleteRow(at index: Int)
    func moveRow(source: Int, destination: Int)
    func saveChanges()
    func cancelChanges()
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
    //    {
    //        didSet { print("tempLC ==========++++========== \(self.tempLifeCycle)") }
    //    }
    
    var isLoading = Publisher(value: Loading.false)
    
    
    //MARK: - Private
    
    private func setObservers() {
        interactor.lifeCycleCard.subscribe(observer: self) { [unowned self] card in
            self.tempLifeCycle.value = card.lifeCycle
            //Два раза идет уведомление, мб из-за того, что сначала меняется дата, потом массив => два раза уведомляет TODO: -
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
        interactor.fetchLifeCycles()
    }
    
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM YYYY"
        return formatter.string(from: interactor.shareStateForMainScene().date)
    }
    
    func getNumberOfLifeCycles() -> Int {
        return tempLifeCycle.value.count
        //        return interactor.shareStateForMainScene().lifeCycle.count
    }
    
    func getCellLabel(at index: Int) -> String {
        return tempLifeCycle.value[index].title
        //        return interactor.shareStateForMainScene().lifeCycle[index].title
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
        tempLifeCycle.value.remove(at: index)
        //        interactor.deleteLifeCycle(at: index)
    }
    
    func moveRow(source: Int, destination: Int) {
        //        tempLifeCycle.value.forEach { print("До изменения \($0.index) \($0.id)") }
        tempLifeCycle.value.rearrange(from: source, to: destination)
        //        tempLifeCycle.value.forEach { print("После изменения \($0.index) \($0.id)") }
        //        print("tempLifeCycle.count == \(tempLifeCycle.count)")
        for i in 0..<tempLifeCycle.value.count {
            //            print("i == \(i)")
            tempLifeCycle.value[i].index = i
            //            print("tempLifeCycle[i].index == \(tempLifeCycle[i].index)")
        }
        //        tempLifeCycle.value.forEach { print("После цикла \($0.index) \($0.id)") }
    }
    
    func cancelChanges() {
        tempLifeCycle.value = interactor.shareStateForMainScene().lifeCycle
    }
    
    func saveChanges() {
        for i in 0..<(tempLifeCycle.value.count != 0 ? tempLifeCycle.value.count : 1)  {
            //            print("i", i)
            //            print("temp", tempLifeCycle.value[i].index, tempLifeCycle.value[i].id)
            //            print("interact", interactor.lifeCycleCard.value.lifeCycle[i].index, interactor.lifeCycleCard.value.lifeCycle[i].id)
            //            print(tempLifeCycle.value[i].id == interactor.lifeCycleCard.value.lifeCycle[i].id)
            if tempLifeCycle.value.count != interactor.lifeCycleCard.value.lifeCycle.count || tempLifeCycle.value[i].id != interactor.lifeCycleCard.value.lifeCycle[i].id {
                interactor.synchronize(new: tempLifeCycle.value)
                return
            }
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

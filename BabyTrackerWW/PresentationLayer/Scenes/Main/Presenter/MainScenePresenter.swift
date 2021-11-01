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
    
    var dateOfCard: String { get }
    var numberOfDreams: Int { get }
    func setCellLabel(at index: Int) -> String
    
    func addObserver(_ callback: @escaping () -> ())
    func addNewDreamButtonTapped()
    func didSelectRow(at index: Int, callback: (String) -> ())
    
    func deleteRow(at index: Int)
    func moveRow(source: Int, destination: Int)
    func saveChanges()
    
    func prepare<T>(for segue: T)
    
    func observeActivity(_ callback: @escaping (Loading) -> ())
    
}

//MARK: - Implementation -

final class MainScenePresenterImpl: MainScenePresenterProtocol {
    
    private let router: MainSceneRouterProtocol
    private let interactor: MainSceneDelegate // мейби ренейм на ДЕЛЕГАТ!?
    //
    // По идее здесь не должно быть менеджера. Вся коммуникация происходит через Юз Кейсы (отдельная сущность.). Каждый юз кейс должен быть не в мейне (кроме основной его задачи отобразить Мейн скрин), а в каждом модуле ответственным за свой функционал. ... Мысль: При таких раскладах тут вырисовывается совсем другая архитектура!
    // Мысль: Можно просто не делать Юз кейсы отдельными сущностями, а реализовать их в виде внутреннего функционала каждого модуля.
    //
    // !!! Стейт манагер реализует все протоколы Юз кейсов. и под видом каждого протокола я раскидываю его одного по всем модулям !!!
    //
    private var tempLifeCycle: [LifeCycle] = []
    { didSet { print("tempLC ==========++++========== \(self.tempLifeCycle)") }}
    
    
    init (router: MainSceneRouterProtocol, interactor: MainSceneDelegate) {
        self.router = router
        self.interactor = interactor
    }
    
    
    func viewDidLoad() {
        interactor.fetchLifeCycles()
        interactor.LCobserve { [unowned self] lc in // 31.10.21 -- test
            self.tempLifeCycle = lc
        }
    }
    
    var dateOfCard: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM YYYY"
        let date = formatter.string(from: interactor.showLifeCyclesCard().date)
        return date
    }
    
    var numberOfDreams: Int {
        let count = interactor.showLifeCyclesCard().lifeCycle.count
        return count
    }
    
    func setCellLabel(at index: Int) -> String {
        let label = interactor.showLifeCyclesCard().lifeCycle[index].title
        return label
    }
    
    func addObserver(_ callback: @escaping () -> ()) {
        interactor.observe(callback)
    }
    
    
    func didSelectRow(at index: Int, callback: (String) -> ()) {
        let type = interactor.showLifeCycleDetails(at: index)
        router.perform(type: type, callback: callback)
    }
    
    //    func didSelectRow(at index: Int, callback: (String) -> ()) {
    //        interactor.showDreamDetails(at: index)
    //    }
    
    func addNewDreamButtonTapped() {
        interactor.addNewLifeCycle()
    }
    
    func deleteRow(at index: Int) {
        tempLifeCycle.remove(at: index)
//        interactor.deleteLifeCycle(at: index)
    }
    
    func moveRow(source: Int, destination: Int) {
        tempLifeCycle.forEach { print("До изменения \($0.index)") }
        tempLifeCycle.rearrange(from: source, to: destination)
        tempLifeCycle.forEach { print("После изменения \($0.index)") }
        print("tempLifeCycle.count == \(tempLifeCycle.count)")
        for i in 0...tempLifeCycle.count - 1 {
            print("i == \(i)")
            tempLifeCycle[i].index = i
            print("tempLifeCycle[i].index == \(tempLifeCycle[i].index)")
        }
        tempLifeCycle.forEach { print("После цикла \($0.index)") }
    }
    
    func saveChanges() {
        interactor.reindex(new: tempLifeCycle)
    }
    
    func prepare<T>(for segue: T) {
        router.prepare(for: segue, delegate: interactor)
    }
    
    
    func observeActivity(_ callback: @escaping (Loading) -> ()) {
        interactor.observeActivity(callback)
    }
    
    
    
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

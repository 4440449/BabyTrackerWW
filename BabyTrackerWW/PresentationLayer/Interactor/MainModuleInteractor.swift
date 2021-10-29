//
//  Interactor.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

// Какая архитектура? МВП + Роутинг для логики переходов. Переходы без логики реализованы в вью.
//Элементы чистой архитектуры (выделены Аппликейшн и Доменные уровни, зависимость от Аппликейшн к домену)
//(Доменный уровень с сущностями и юз кейсами (протоколы к Стейт манагеру); Отдельный презентейшн слой (уровень взаимодействия и работы модулей на аппликейшн уровне); Направление зависимостей - из вне к центру (Доменный уровень не знает ни о ком, Все знают про доменный уровень. Дата леер работает только с сущностями доменного увроня, не знает о презентейшн слое. Презентейшн слой работает с доменными сущностями, использует их поведение, знает о Дата уровне - зависит от его состояния, меняет его состояние.)
// Использован подход Протокол ориентированного программирования. Логика для взаимодействия всех модулей инкапсулирована в протоколы.
// Паттерн "Обзервинг" - обмен данными в реактивном стиле между слоями Презентейшн (Мейн сцена) и Дата аксес
// Паттерн "Стейт машина" - состояние Презентейшн слоя зависит от изменения состояния Дата слоя (Стейт менеджера)
// Переиспользуемый модуль Пикер сцены) - Наверно это не совсем то, что вкладывается в понятие "переиспользуемость"
// ПС Вообще архитектура более смахивает на ВАЙПЕР, где стор менеджер это интерактор для 3 экранов, т.е. получается один большой модуль. Или один Флоу.
// Размыть обратную связь, возврат данных через колбеки / обзервинг

// Т.к. основная логика находится в Мейн сцене, решил не делать отдельные модели для Календпрь и Детейл сцен. Для изменения состояния Мейн Модели передаю ее остальным вьюхав в виде делегата закрытого соответствующим протоколом.

import Foundation



// MARK: - Main Module Use Cases -

protocol MainSceneDelegate: AnyObject {
    
    func fetchLifeCycles()
    
    func observe(_ callback: @escaping () -> ())
    func showLifeCyclesCard() -> LifeCyclesCard
    func showLifeCycleDetails(at index: Int) -> LifeCycle
    func addNewLifeCycle()
    func deleteLifeCycle(at index: Int)
    
    func observeActivity(_ callback: @escaping (Loading) -> ())
}

protocol CalendarSceneDelegate: AnyObject {
    func showDate() -> Date
    func changeDate(new date: Date)
}

protocol DetailSceneDelegate: AnyObject { // нах тут протококл ДримДелегат???
    func showLifeCycle() -> LifeCycle
    func changeLifeCycle(new lifeCycle: LifeCycle)
    func getAvailableIndex() -> Int
}


protocol SelectSceneDelegate: AnyObject {
}


// MARK: - Implementation -

final class MainModuleInteractorImpl: MainSceneDelegate, CalendarSceneDelegate, DetailSceneDelegate, SelectSceneDelegate {

    private let repository: LifeCyclesCardGateway // dataAccessGateway
    
    
    private var notifierStorage: [() -> ()] = []
    private var currentLifecycleIndex: Int?
    
    private var lifeCycleCard = LifeCyclesCard(date: Date()) {
        didSet { DispatchQueue.main.async { self.notifierStorage.forEach{$0()} } }
    }
    
    // ------
    private var isLoading: Loading? {
        didSet {
            DispatchQueue.main.async { self.notifierActivityStorage.forEach{$0(self.isLoading!)} }
        }
    }
    
    private var notifierActivityStorage: [(Loading) -> ()] = []
    
    
    func observeActivity(_ callback: @escaping (Loading) -> ()) {
        self.notifierActivityStorage.append(callback)
    }
    // ------

    init(persistenceRepository: LifeCyclesCardGateway) {
        self.repository = persistenceRepository
    }
    
    func fetchLifeCycles() {
        isLoading = .loading // -------
        repository.fetchLifeCycle(at: lifeCycleCard.date) { [unowned self] result in
            switch result {
            case let .success(lifeCycle): self.lifeCycleCard.lifeCycle = lifeCycle.sorted { $0.index < $1.index }
            case let .failure(error): print("fetchDreamsCard() / Dreams cannot be received. Error description: \(error)") // handle error!
            }
            self.isLoading = .notLoading // -------
        }
    }
    
    //MARK: - Main Scene
    
    func observe(_ callback: @escaping () -> ()) { // Обзервинг надо вынести в отдельный протокол для заинтересованных
        self.notifierStorage.append(callback)
    }
    
    func showLifeCyclesCard() -> LifeCyclesCard {
        return lifeCycleCard
    }
    
    // addNew flow
    func addNewLifeCycle() {
        currentLifecycleIndex = nil
    }
    // didSelect flow
    func showLifeCycleDetails(at index: Int) -> LifeCycle {
        currentLifecycleIndex = index
        return lifeCycleCard.lifeCycle[index]
        
    }
    
    func deleteLifeCycle(at index: Int) {
        repository.deleteLifeCycle(lifeCycleCard.lifeCycle[index]/* as! Dream*/) { [unowned self] result in
            switch result {
            case .success(): self.lifeCycleCard.lifeCycle.remove(at: index)
            case let .failure(error): print("deleteAction() / Dream cannot be deleted. Error description: \(error)")
            }
        }
    }
    
    //MARK: - Calendar Scene
    
    func showDate() -> Date {
        return lifeCycleCard.date
    }
    
    func changeDate(new date: Date) {
        repository.fetchLifeCycle(at: date) { [unowned self] result in
            self.lifeCycleCard.date = date
            switch result {
            case let .success(lifeCycles): self.lifeCycleCard.lifeCycle = lifeCycles;
            case let .failure(error): print("setDate() / Dreams cannot be received on the selected date. Error description: \(error)")
            }
        }
    }
    
    //MARK: - Detail Scene
    
    func getAvailableIndex() -> Int {
        return lifeCycleCard.lifeCycle.endIndex
    }
    
    func showLifeCycle() -> LifeCycle {
        return lifeCycleCard.lifeCycle[currentLifecycleIndex!]
    }
    
    func changeLifeCycle (new lifeCycle: LifeCycle) {
        if currentLifecycleIndex == nil {
            // addNew Flow
            repository.addNewLifeCycle(new: lifeCycle, at: lifeCycleCard.date) { [unowned self] result in
                switch result {
                case .success(): self.lifeCycleCard.lifeCycle.append(lifeCycle)
                case let .failure(error): print("setDream() / New Dream cannot be added. Error description: \(error)")
                }
            }
        } else {
            // didSelectFlow
            repository.changeLifeCycle(lifeCycle) { [unowned self] result in
                switch result {
                case .success(): self.lifeCycleCard.lifeCycle[self.currentLifecycleIndex!] = lifeCycle
                case let .failure(error): print("setDream() / Dream cannot be changed. Error description: \(error)")
                }
            }
        }
    }

    //MARK: - Select Scene


    
}

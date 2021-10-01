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


protocol DreamDelegate {} // нах протококл ДримДелегат???

// MARK: - Main Module Use Cases -

protocol MainSceneDelegate: AnyObject {
    
    func fetchDreams()
    
    func observe(_ callback: @escaping () -> ())
    func showDreamsCard() -> DreamsCard
    func addNewDream()
    func showDreamDetails(at index: Int) -> LifeCycle
    func deleteDream(at index: Int)
    
    func observeActivity(_ callback: @escaping (Loading) -> ())
}

protocol CalendarSceneDelegate: AnyObject {
    func showDate() -> Date
    func changeDate(new date: Date)
}

protocol DetailSceneDelegate: AnyObject, DreamDelegate { // нах тут протококл ДримДелегат???
    func showLifeCycle() -> LifeCycle
    func changeLifeCycle(new lifeCycle: LifeCycle)
    func getAvailableIndex() -> Int
}


protocol SelectSceneDelegate: AnyObject {
}


// MARK: - Implementation -

final class MainModuleInteractorImpl: MainSceneDelegate, CalendarSceneDelegate, DetailSceneDelegate, /*WakeDetailSceneDelegate,*/ SelectSceneDelegate {

    private let persistenceRepository: DreamsCardGateway
    
    private var notifierStorage: [() -> ()] = []
    private var currentLifecycleIndex: Int?
    
    private var dreamsCard = DreamsCard(date: Date()) {
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

    init(persistenceRepository: DreamsCardGateway) {
        self.persistenceRepository = persistenceRepository
//        fetchDreams() // убрать запрос из инициализатора, т.к. нужен прогруз мейн сцены для активации лоадинг анимации и после этого уже запускать запрос в бекграунд поток
    }
    
    func fetchDreams() {
        isLoading = .loading // -------
        persistenceRepository.fetchLifeCycle(at: dreamsCard.date) { [unowned self] result in
            switch result {
            case let .success(lifeCycle): self.dreamsCard.lifeCycle = lifeCycle
            case let .failure(error): print("fetchDreamsCard() / Dreams cannot be received. Error description: \(error)")
            }
            self.isLoading = .notLoading // -------
        }
    }
    
    //MARK: - Main Scene
    
    func observe(_ callback: @escaping () -> ()) { // Обзервинг надо вынести в отдельный протокол для заинтересованных
        self.notifierStorage.append(callback)
    }
    
    func showDreamsCard() -> DreamsCard {
        return dreamsCard
    }
    
    // addNew flow
    func addNewDream() {
        currentLifecycleIndex = nil
    }
    // didSelect flow
    func showDreamDetails(at index: Int) -> LifeCycle {
        currentLifecycleIndex = index
        return dreamsCard.lifeCycle[index]
        
    }
    
    func deleteDream(at index: Int) {
        persistenceRepository.deleteLifeCycle(dreamsCard.lifeCycle[index]/* as! Dream*/) { [unowned self] result in
            switch result {
            case .success(): self.dreamsCard.lifeCycle.remove(at: index)
            case let .failure(error): print("deleteAction() / Dream cannot be deleted. Error description: \(error)")
            }
        }
    }
    
    //MARK: - Calendar Scene
    
    func showDate() -> Date {
        return dreamsCard.date
    }
    
    func changeDate(new date: Date) {
        persistenceRepository.fetchLifeCycle(at: date) { [unowned self] result in
            switch result {
            case let .success(lifeCycles): self.dreamsCard.date = date;
            self.dreamsCard.lifeCycle = lifeCycles;
            case let .failure(error): print("setDate() / Dreams cannot be received on the selected date. Error description: \(error)")
            }
        }
    }
    
    //MARK: - Dream Detail Scene
    
    func getAvailableIndex() -> Int {
        // TODO: Не нравится реализация, метод полностью дублируется. Задача - получить последний, свободный индекс
        return dreamsCard.lifeCycle.endIndex
    }
    
    func showLifeCycle() -> LifeCycle {
        return dreamsCard.lifeCycle[currentLifecycleIndex!] // as! Dream
    }
    
    func changeLifeCycle (new lifeCycle: LifeCycle) {
        if currentLifecycleIndex == nil {
            // addNew Flow
            persistenceRepository.addNewLifeCycle(new: lifeCycle, at: dreamsCard.date) { [unowned self] result in
                switch result {
                case .success(): self.dreamsCard.lifeCycle.append(lifeCycle)
                case let .failure(error): print("setDream() / New Dream cannot be added. Error description: \(error)")
                }
            }
        } else {
            // didSelectFlow
            persistenceRepository.changeLifeCycle(lifeCycle) { [unowned self] result in
                switch result {
                case .success(): self.dreamsCard.lifeCycle[self.currentLifecycleIndex!] = lifeCycle
                case let .failure(error): print("setDream() / Dream cannot be changed. Error description: \(error)")
                }
            }
        }
    }

    //MARK: - Select Scene


    
}

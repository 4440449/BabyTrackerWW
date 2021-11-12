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
    
//    func subscribeToCardState(_ observer: AnyObject, _ callback: @escaping () -> ())
//    func subscribeToLoadingState(_ observer: AnyObject, _ callback: @escaping (Loading) -> ())
//    func unsubscribeToCardState(_ observer: AnyObject)
//    func unsubscribeToLoadingState(_ observer: AnyObject)
    
    func shareStateForMainScene() -> LifeCyclesCard
    func fetchLifeCycles()
    func saveChanges(new lifeCycles: [LifeCycle])
    
    func deleteLifeCycle(at index: Int)
    func synchronize(new lifeCycles: [LifeCycle])
    
    var lifeCycleCard: Publisher<LifeCyclesCard> { get }
    var isLoading: Publisher<Loading> { get }
}


protocol CalendarSceneDelegate: AnyObject {
    
    func shareStateForCalendarScene() -> LifeCyclesCard
    
    func changeDate(new date: Date)
}


protocol DetailSceneDelegate: AnyObject {
    
    func shareStateForDetailScene() -> LifeCyclesCard
    
    func add(new lifeCycle: LifeCycle)
    func change(current lifeCycle: LifeCycle)
}


protocol SelectSceneDelegate: AnyObject {
    
}



// MARK: - Implementation -

final class MainModuleInteractorImpl: MainSceneDelegate, CalendarSceneDelegate, DetailSceneDelegate, SelectSceneDelegate {
    
    
    // MARK: - Dependencies
    
    private let repository: LifeCyclesCardGateway
    
    init(repository: LifeCyclesCardGateway) {
        self.repository = repository
    }
    
    
    // MARK: - State
    
    var lifeCycleCard = Publisher(value: LifeCyclesCard(date: Date()))
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.cardStateNotifierStorage.forEach { $0.callback(()) }
//            }
//        }
//    }
    
    var isLoading = Publisher(value: Loading.false)
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.loadingStateNotifierStorage.forEach{ $0.callback(self.isLoading) }
//            }
//        }
//    }
        
    
    // MARK: - Observing
    
//    private var cardStateNotifierStorage = [Observer<Void>]() { didSet { print(self.cardStateNotifierStorage.count)
//        }
//    }
//    private var loadingStateNotifierStorage = [Observer<Loading>]()
//
//
//    func subscribeToCardState(_ observer: AnyObject, _ callback: @escaping () -> ()) {
//        cardStateNotifierStorage.append(Observer(observer, callback))
//    }
//
//    func subscribeToLoadingState(_ observer: AnyObject, _ callback: @escaping (Loading) -> ()) {
//        loadingStateNotifierStorage.append(Observer(observer, callback))
//    }
//
//    func unsubscribeToCardState(_ observer: AnyObject) {
//        cardStateNotifierStorage = cardStateNotifierStorage.filter { $0.observer !== observer }
//    }
//
//    func unsubscribeToLoadingState(_ observer: AnyObject) {
//        loadingStateNotifierStorage = loadingStateNotifierStorage.filter { $0.observer !== observer }
//    }
    
    
    //MARK: - Main Scene
    
    func shareStateForMainScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func fetchLifeCycles() {
        isLoading.value = .true
        repository.fetch(at: lifeCycleCard.value.date) { [unowned self] result in
//            print(result)
            switch result {
            case let .success(lifeCycles): self.lifeCycleCard.value.lifeCycle = lifeCycles
            case let .failure(error): print("fetchDreamsCard() / Dreams cannot be received. Error description: \(error)") // handle error!
            }
            self.isLoading.value = .false
        }
    }
    
    func saveChanges(new lifeCycles: [LifeCycle]) {
        
    }
    
    func deleteLifeCycle(at index: Int) {
        isLoading.value = .true
        repository.delete(lifeCycleCard.value.lifeCycle[index], at: lifeCycleCard.value.date) { [unowned self] result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.remove(at: index)
            case let .failure(error): print("deleteAction() / Dream cannot be deleted. Error description: \(error)")
            }
            self.isLoading.value = .false
        }
    }
    
    func synchronize(new lifeCycles: [LifeCycle]) {
        isLoading.value = .true
        repository.synchronize(new: lifeCycles, date: lifeCycleCard.value.date) { result in
            switch result {
            case .success(()): self.lifeCycleCard.value.lifeCycle = lifeCycles
            case let .failure(error): print("reindex() / Error description: \(error)")
            }
            self.isLoading.value = .false
        }
    }
    
    
    //MARK: - Calendar Scene
    
    func shareStateForCalendarScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func changeDate(new date: Date) {
        guard date != lifeCycleCard.value.date else { return }
        isLoading.value = .true
        repository.fetch(at: date) { [unowned self] result in
            self.lifeCycleCard.value.date = date
            switch result {
            case let .success(lifeCycles): self.lifeCycleCard.value.lifeCycle = lifeCycles;
            case let .failure(error): print("setDate() / Dreams cannot be received on the selected date. Error description: \(error)")
            }
            self.isLoading.value = .false
        }
    }
    
    
    //MARK: - Detail Scene
    
    func shareStateForDetailScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func add(new lifeCycle: LifeCycle) {
        isLoading.value = .true
        repository.add(new: lifeCycle, at: lifeCycleCard.value.date) { [unowned self] result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.append(lifeCycle)
            case let .failure(error): print("setDream() / New Dream cannot be added. Error description: \(error)")
            }
            self.isLoading.value = .false
        }
    }
    
    func change(current lifeCycle: LifeCycle) {
        isLoading.value = .true
        repository.change(current: lifeCycle, at: lifeCycleCard.value.date) { [unowned self] result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle[lifeCycle.index] = lifeCycle
            case let .failure(error): print("setDream() / Dream cannot be changed. Error description: \(error)")
            }
            self.isLoading.value = .false
        }
    }
    
    
    //MARK: - Select Scene
    
    
    
}

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
    
    var lifeCycleCard: Publisher<LifeCyclesCard> { get }
    var isLoading: Publisher<Loading> { get }
    var error: Publisher<String> { get }
    func shareStateForMainScene() -> LifeCyclesCard
    
    func fetchLifeCycles(at date: Date)
    func synchronize(newValue: [LifeCycle])
}


protocol CalendarSceneDelegate: AnyObject {
    
    func shareStateForCalendarScene() -> LifeCyclesCard
    func changeDate(new date: Date)
}


protocol DetailDreamSceneDelegate: AnyObject {
    
    func shareStateForDetailDreamScene() -> LifeCyclesCard
    
    func add(new dream: Dream)
    func change(_ dream: Dream)
}


protocol DetailWakeSceneDelegate: AnyObject {
    
    func shareStateForDetailWakeScene() -> LifeCyclesCard
    
    func add(new wake: Wake)
    func change(_ wake: Wake)
}


protocol SelectSceneDelegate {
    
}



// MARK: - Implementation -

final class MainModuleInteractorImpl: MainSceneDelegate, CalendarSceneDelegate, DetailDreamSceneDelegate, DetailWakeSceneDelegate, SelectSceneDelegate {
    
    
    // MARK: - Dependencies
    
    private let dreamRepository: DreamGatewayProtocol
    private let wakeRepository: WakeGatewayProtocol
    private let lifecycleCardRepository: LifeCyclesCardGateway
    
    init(dreamRepository: DreamGatewayProtocol, wakeRepository: WakeGatewayProtocol, lifecycleCardRepository: LifeCyclesCardGateway) {
        self.dreamRepository = dreamRepository
        self.wakeRepository = wakeRepository
        self.lifecycleCardRepository = lifecycleCardRepository
    }
    
    
    // MARK: - State
    
    var lifeCycleCard = Publisher(value: LifeCyclesCard(date: Date()))
    var isLoading = Publisher(value: Loading.false)
    var error = Publisher(value: "")
    
    
    // MARK: - Private
    
    private func handleError(error: Error) {
        switch error {
        case _ where error is LocalStorageError:
            self.error.value = "Ошибка локального хранилища \(error.localizedDescription)";
            print(error)
            
        case let networkError as NetworkError:
            switch networkError {
            case .badRequest(_): self.error.value = "Кажется проблема с интернет-соединением. Проверьте подключение"
            case .badResponse(_): self.error.value = "Проблема на стороне сервера. Код ошибки: \(networkError.localizedDescription)"
            default: self.error.value = "Внутренняя ошибка"
            }
            
        default:
            self.error.value = "Неизвестная ошибка \(error.localizedDescription)";
            print(error)
        }
    }
    
    
    //MARK: - Main Scene
    
    func shareStateForMainScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func fetchLifeCycles(at date: Date) {
        isLoading.value = .true
        lifecycleCardRepository.fetch(at: date) { result in
            switch result {
            case let .success(lifeCycles): self.lifeCycleCard.value.lifeCycle = lifeCycles
            case let .failure(error):
                self.lifeCycleCard.value.lifeCycle = []
                self.handleError(error: error)
            }
            self.lifeCycleCard.value.date = date
            self.isLoading.value = .false
        }
    }
    
    func synchronize(newValue: [LifeCycle]) {
        isLoading.value = .true
        lifecycleCardRepository.update(newValue: newValue, oldValue: lifeCycleCard.value.lifeCycle, date: lifeCycleCard.value.date) { result in
            switch result {
            case .success(()): self.lifeCycleCard.value.lifeCycle = newValue
            case let .failure(error):
                self.lifeCycleCard.notify();
                self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    //    func deleteLifeCycle(at index: Int) {
    //        isLoading.value = .true
    //        repository.delete(lifeCycleCard.value.lifeCycle[index], at: lifeCycleCard.value.date) { [unowned self] result in
    //            switch result {
    //            case .success(): self.lifeCycleCard.value.lifeCycle.remove(at: index)
    //            case let .failure(error): print("deleteAction() / Dream cannot be deleted. Error description: \(error)")
    //            }
    //            self.isLoading.value = .false
    //        }
    //    }
    
    //MARK: - Calendar Scene
    
    func shareStateForCalendarScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func changeDate(new date: Date) {
        guard date != lifeCycleCard.value.date else { return }
        fetchLifeCycles(at: date)
    }
    
    
    //MARK: - Detail Dream Scene
    
    func shareStateForDetailDreamScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func add(new dream: Dream) {
        isLoading.value = .true
        dreamRepository.add(new: dream, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.append(dream)
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    func change(_ dream: Dream) {
        isLoading.value = .true
        dreamRepository.change(dream, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle[dream.index] = dream
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    
    //MARK: - Detail Wake Scene
    
    func shareStateForDetailWakeScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func add(new wake: Wake) {
        isLoading.value = .true
        wakeRepository.add(new: wake, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.append(wake)
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    func change(_ wake: Wake) {
        isLoading.value = .true
        wakeRepository.change(wake, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle[wake.index] = wake
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
}

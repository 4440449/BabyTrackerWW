//
//  Interactor.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import MommysEye


// MARK: - Main Module Use Cases -

protocol MainSceneDelegate_BTWW: AnyObject {
    
    var lifeCycleCard: Publisher<LifeCyclesCard> { get }
    var isLoading: Publisher<Loading> { get }
    var error: Publisher<String> { get }
    func shareStateForMainScene() -> LifeCyclesCard
    
    func fetchLifeCycles(at date: Date)
    func synchronize(newValue: [LifeCycle])
}


protocol CalendarSceneDelegate_BTWW: AnyObject {
    
    func shareStateForCalendarScene() -> LifeCyclesCard
    func changeDate(new date: Date)
}


protocol DetailDreamSceneDelegate_BTWW: AnyObject {
    
    func shareStateForDetailDreamScene() -> LifeCyclesCard
    
    func add(new dream: Dream)
    func change(_ dream: Dream)
}


protocol DetailWakeSceneDelegate_BTWW: AnyObject {
    
    func shareStateForDetailWakeScene() -> LifeCyclesCard
    
    func add(new wake: Wake)
    func change(_ wake: Wake)
}




// MARK: - Implementation -

final class Interactor_BTWW: MainSceneDelegate_BTWW, CalendarSceneDelegate_BTWW, DetailDreamSceneDelegate_BTWW, DetailWakeSceneDelegate_BTWW {
    
    
    // MARK: - Dependencies
    
    private let dreamRepository: DreamGateway
    private let wakeRepository: WakeGateway
    private let lifecycleCardRepository: LifeCyclesCardGateway
    
    init(dreamRepository: DreamGateway, wakeRepository: WakeGateway, lifecycleCardRepository: LifeCyclesCardGateway) {
        self.dreamRepository = dreamRepository
        self.wakeRepository = wakeRepository
        self.lifecycleCardRepository = lifecycleCardRepository
    }
    
    
    // MARK: - State
    
    var lifeCycleCard = Publisher(value: LifeCyclesCard(date: Date()))
    var isLoading = Publisher(value: Loading.false)
    var error = Publisher(value: "")
    
    
    // MARK: Private
    
    private var task: Cancellable? { willSet { self.task?.cancel() } }
    
    
    // MARK: - Private
    
    private func handleError(error: Error) {
        switch error {
        case _ where error is LocalStorageError:
            self.error.value = "Ошибка локального хранилища \(error.localizedDescription)";
            print(error)
        default:
            self.error.value = "Неизвестная ошибка \(error.localizedDescription)";
            print(error)
        }
    }
    
    
    // MARK: - Interfaces -
    
    //MARK: - Main Scene
    
    func shareStateForMainScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func fetchLifeCycles(at date: Date) {
        isLoading.value = .true
        task = lifecycleCardRepository.fetch(at: date) { result in
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
        task = lifecycleCardRepository.update(newValue: newValue, oldValue: lifeCycleCard.value.lifeCycle, date: lifeCycleCard.value.date) { result in
            switch result {
            case .success(()): self.lifeCycleCard.value.lifeCycle = newValue
            case let .failure(error):
                self.lifeCycleCard.notify();
                self.handleError(error: error)
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
        fetchLifeCycles(at: date)
    }
    
    
    //MARK: - Detail Dream Scene
    
    func shareStateForDetailDreamScene() -> LifeCyclesCard {
        return lifeCycleCard.value
    }
    
    func add(new dream: Dream) {
        isLoading.value = .true
        task = dreamRepository.add(new: dream, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.append(dream)
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    func change(_ dream: Dream) {
        isLoading.value = .true
        task = dreamRepository.change(dream, at: lifeCycleCard.value.date) { result in
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
        task = wakeRepository.add(new: wake, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle.append(wake)
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
    func change(_ wake: Wake) {
        isLoading.value = .true
        task = wakeRepository.change(wake, at: lifeCycleCard.value.date) { result in
            switch result {
            case .success(): self.lifeCycleCard.value.lifeCycle[wake.index] = wake
            case let .failure(error): self.handleError(error: error)
            }
            self.isLoading.value = .false
        }
    }
    
}

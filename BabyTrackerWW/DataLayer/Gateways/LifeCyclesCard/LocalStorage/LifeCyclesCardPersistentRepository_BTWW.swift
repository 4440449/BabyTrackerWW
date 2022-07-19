//
//  LifeCyclesCardPersistentRepository_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCyclesCardPersistentRepositoryProtocol_BTWW {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func synchronize(newValue: [LifeCycle], oldValue: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



final class LifeCyclesCardPersistentRepository_BTWW: LifeCyclesCardPersistentRepositoryProtocol_BTWW {
    
    
    // MARK: - Dependencies
    
    private let dreamRepository: DreamPersistentRepositoryProtocol_BTWW
    private let wakeRepository: WakePersistentRepositoryProtocol_BTWW
    
    init(dreamRepository: DreamPersistentRepositoryProtocol_BTWW,
         wakeRepository: WakePersistentRepositoryProtocol_BTWW) {
        self.wakeRepository = wakeRepository
        self.dreamRepository = dreamRepository
    }
    
    
    // MARK: - Implementation
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        var resultSuccess = [LifeCycle]()
        let serialQ = DispatchQueue(label: "serialQ")
        let taskItem2 = DispatchWorkItem {
            self.wakeRepository.fetchWakes(at: date) { result in
                switch result {
                case let .success(wakes):
                    resultSuccess.append(contentsOf: wakes);
                    callback(.success(resultSuccess.sorted { $0.index < $1.index } ))
                case let .failure(error):
                    callback(.failure(error))
                }
            }
        }
        let taskItem1 = DispatchWorkItem {
            self.dreamRepository.fetchDreams(at: date) { result in
                switch result {
                case let .success(dreams):
                    resultSuccess.append(contentsOf: dreams)
                case let .failure(error):
                    taskItem2.cancel()
                    callback(.failure(error))
                }
            }
        }
        serialQ.async(execute: taskItem1)
        serialQ.sync(execute: taskItem2)
    }
    
    
    func synchronize(newValue: [LifeCycle], oldValue: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        let newValueDreams = newValue.compactMap { $0 as? Dream }
        let newValueWakes = newValue.compactMap { $0 as? Wake }
        
        let oldValueDreams = oldValue.compactMap { $0 as? Dream }
        //        let oldValuesWakes = lifeCycles.compactMap { $0 as? Wake }
        
        let serialQ = DispatchQueue(label: "serialQ")
        let taskItem2 = DispatchWorkItem {
            self.wakeRepository.update(wakes: newValueWakes, date: date) { result in
                switch result {
                case .success():
                    callback(.success(()))
                case let .failure(wakeRepoError):
                    self.cancelChanges(dreams: oldValueDreams, date: date)
                    callback(.failure(wakeRepoError))
                }
            }
        }
        let taskItem1 = DispatchWorkItem {
            self.dreamRepository.update(newValueDreams, at: date) { result in
                switch result {
                case .success():
                    return
                case let .failure(dreamRepoError):
                    taskItem2.cancel()
                    callback(.failure(dreamRepoError))
                }
            }
        }
        serialQ.async(execute: taskItem1)
        serialQ.async(execute: taskItem2)
    }
    
    
    // MARK: - Private
    
    private func cancelChanges(dreams: [Dream], date: Date) {
        dreamRepository.update(dreams, at: date) { result in
            switch result {
            case .success:
                print("::: Сhanges canceled after failed synchronization")
            case let .failure(syncError):
                print("Сhanges are not canceled after failed synchronization :: Error \(syncError)")
            }
        }
    }
    
    private func cancelChanges(wakes: [Wake], date: Date) {
        wakeRepository.update(wakes: wakes, date: date) { result in
            switch result {
            case .success:
                print("::: Сhanges canceled after failed synchronization")
            case let .failure(syncError):
                print("Сhanges are not canceled after failed synchronization :: Error \(syncError)")
            }
        }
    }
    
}

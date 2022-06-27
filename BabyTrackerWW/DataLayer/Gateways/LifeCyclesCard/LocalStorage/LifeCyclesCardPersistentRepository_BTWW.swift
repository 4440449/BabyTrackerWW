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
        
        let serialQ = DispatchQueue.init(label: "serialQ")
        serialQ.async {
//            sleep(1)
            var breakTask = false
            
            self.dreamRepository.fetchDreams(at: date) { result in
                switch result {
                case let .success(dreams):
                    resultSuccess.append(contentsOf: dreams)
                case let .failure(error):
                    breakTask = true;
                    callback(.failure(error))
                }
            }
            guard !breakTask else { return }
            
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
        
    }
    
    
    func synchronize(newValue: [LifeCycle], oldValue: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        let newValueDreams = newValue.compactMap { $0 as? Dream }
        let newValueWakes = newValue.compactMap { $0 as? Wake }
        
        let oldValueDreams = oldValue.compactMap { $0 as? Dream }
        // Если пустой массив придет?
        //        let oldValuesWakes = lifeCycles.compactMap { $0 as? Wake }
        //Многопоточный доступ в кор дату - можно?
        
        let serialQ = DispatchQueue.init(label: "localStorageSerialQ")
        serialQ.async {
            var breakTask = false
            
            self.dreamRepository.update(newValueDreams, at: date) { result in
                switch result {
                case .success(): return
                case let .failure(dreamRepoError):
                    breakTask = true;
                    callback(.failure(dreamRepoError))
                }
            }
            
            guard !breakTask else { return }
            
            self.wakeRepository.update(wakes: newValueWakes, date: date) { result in
                switch result {
                case .success(): callback(.success(()))
                case let .failure(wakeRepoError):
                    self.cancelChanges(dreams: oldValueDreams, date: date);
                    callback(.failure(wakeRepoError))
                }
            }
        }
        
    }
    
    
    // MARK: - Private
    
    private func cancelChanges(dreams: [Dream], date: Date) {
        dreamRepository.update(dreams, at: date) { result in
            switch result {
            case .success: print("::: Сhanges canceled after failed synchronization")
            case let .failure(syncError): print("Сhanges are not canceled after failed synchronization :: Error \(syncError)")
            }
        }
    }
    
    private func cancelChanges(wakes: [Wake], date: Date) {
        wakeRepository.update(wakes: wakes, date: date) { result in
            switch result {
            case .success: print("::: Сhanges canceled after failed synchronization")
            case let .failure(syncError): print("Сhanges are not canceled after failed synchronization :: Error \(syncError)")
            }
        }
    }
    
}

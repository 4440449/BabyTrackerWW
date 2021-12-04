//
//  LifeCyclesCardPersistentRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCyclesCardPersistentRepositoryProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func synchronize(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



final class LifeCyclesCardPersistentRepositoryImpl: LifeCyclesCardPersistentRepositoryProtocol {
    
    
    // MARK: - Dependencies
    
    private let dreamRepository: DreamPersistentRepositoryProtocol
    private let wakeRepository: WakePersistentRepositoryProtocol
    
    init(dreamRepository: DreamPersistentRepositoryProtocol,
         wakeRepository: WakePersistentRepositoryProtocol) {
        self.wakeRepository = wakeRepository
        self.dreamRepository = dreamRepository
    }
    
    
    // MARK: - Implements
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        
        var resultSuccess = [LifeCycle]()
        
        let serialQ = DispatchQueue.init(label: "serialQ")
        serialQ.async {
            sleep(1)
            var breakTask = false
            //Несколько обращений к базе - плохая практика, проседает перформанс / Разве в моем случае можно по другому? :(
            self.dreamRepository.fetchDreams(at: date) { result in
                switch result {
                case let .success(dreams): resultSuccess.append(contentsOf: dreams)
                case let .failure(error): breakTask = true; callback(.failure(error))
                }
            }
            guard !breakTask else { return }
            
            self.wakeRepository.fetchWakes(at: date) { result in
                switch result {
                case let .success(wakes): resultSuccess.append(contentsOf: wakes)
                case let .failure(error): callback(.failure(error))
                }
            }
            
            callback(.success(resultSuccess.sorted { $0.index < $1.index } ))
        }
    }
    
    
    func synchronize(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        let dreams = lifeCycles.compactMap { $0 as? Dream }
        let wakes = lifeCycles.compactMap { $0 as? Wake }
        //Многопоточный доступ в кор дату - можно?
        
        let serialQ = DispatchQueue.init(label: "localStorageSerialQ")
        serialQ.async {
            var breakTask = false
            
            self.dreamRepository.update(dreams, at: date) { result in
                switch result {
                case . success(): return
                case let .failure(dreamRepoError): breakTask = true; callback(.failure(dreamRepoError))
                }
            }
            
            guard !breakTask else { return }
            
            self.wakeRepository.update(wakes: wakes, date: date) { result in
                switch result {
                case .success(): return
                case let .failure(wakeRepoError): callback(.failure(wakeRepoError))
                }
            }
        }
    }
    
}

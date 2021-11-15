//
//  LifeCyclesCardPersistenceRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 14.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCyclesCardPersistenceRepositoryProtocol {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func synchronize(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
}



final class LifeCyclesCardPersistenceRepositoryImpl: LifeCyclesCardPersistenceRepositoryProtocol {
    
    
    // MARK: - Dependencies
    
    private let dreamRepository: DreamPersistenceRepositoryProtocol
    private let wakeRepository: WakePersistenceRepositoryProtocol
    
    init(dreamRepository: DreamPersistenceRepositoryProtocol,
        wakeRepository: WakePersistenceRepositoryProtocol) {
        self.wakeRepository = wakeRepository
        self.dreamRepository = dreamRepository
    }
    
    struct PersistenceRepositoryError: Error {
        var description = [String]()
        // Объединить или убрать эту ошибку
    }
    
    // MARK: - Implements

    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        
        var resultError = PersistenceRepositoryError() // TODO: - Extension native Error type (add [description] property)
        var resultSuccess = [LifeCycle]()
        
        let serialQ = DispatchQueue.init(label: "serialQ")
        serialQ.async {
            sleep(3)
            //Несколько обращений к базе - плохая практика, проседает перформанс / Разве в моем случае можно по другому? :(
            self.wakeRepository.fetchWakes(at: date) { result in
                switch result {
                case let .success(wakes): resultSuccess.append(contentsOf: wakes)
                case let .failure(error): resultError.description.append(error.localizedDescription)
                }
            }
            
            self.dreamRepository.fetchDreams(at: date) { result in
                switch result {
                case let .success(dreams): resultSuccess.append(contentsOf: dreams)
                case let .failure(error): resultError.description.append(error.localizedDescription)
                }
            }
            
            if !resultError.description.isEmpty {
                callback(.failure(resultError))
            } else {
                callback(.success(resultSuccess.sorted { $0.index < $1.index } ))
            }
            // TODO: Более красиво обработать остановку задачи, при наличии хотя бы одной ошибки (Operation?)
        }
    }
    
    
    func synchronize(new lifeCycles: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        //Оттестить значения, если в одном из придет нил, проинитится пустой массив? Вообще безопасная конструкция?
        let dreams = lifeCycles.compactMap { $0 as? Dream }
        //        print("dreams ===== \(dreams)")
        let wakes = lifeCycles.compactMap { $0 as? Wake }
        //        print("wakes ===== \(wakes)")
        var resultError = PersistenceRepositoryError()
        //Многопоточный доступ в кор дату - можно?
        let serialQ = DispatchQueue.init(label: "localStorageSerialQ")
        serialQ.async {
            sleep(3)
            
            self.wakeRepository.update(wakes: wakes, date: date) { result in
                switch result {
                case .success(): return
                case let .failure(wakeRepoError): resultError.description.append(wakeRepoError.localizedDescription)
                }
            }
            
            self.dreamRepository.synchronize(dreams: dreams, date: date) { result in
                switch result {
                case . success(): return
                case let .failure(dreamRepoError): resultError.description.append(dreamRepoError.localizedDescription)
                }
            }
            
            if !resultError.description.isEmpty {
                callback(.failure(resultError))
            } else {
                callback(.success(()))
            }
        }
    }
    
}

//
//  PersistenceRepositoryGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 29.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


final class PersistenceRepositoryGateway: LifeCyclesCardGateway {
    
    struct PersistenceRepositoryError: Error {
        var description = [String]()
    }
    
    private let wakeRepository: WakeGatewayProtocol
    private let dreamRepository: DreamGatewayProtocol
    
    init(wakeRepository: WakeGatewayProtocol, dreamRepository: DreamGatewayProtocol) {
        self.wakeRepository = wakeRepository
        self.dreamRepository = dreamRepository
    }
    
    
    func fetchLifeCycle(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        
        var resultSuccess = [LifeCycle]()
        var resultError = PersistenceRepositoryError()
        
        let serialQ = DispatchQueue.init(label: "serialQ")
        serialQ.async {
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
                callback(.success(resultSuccess.sorted { $0.index < $1.index }))
            }
            // TODO: Более красиво обработать остановку задачи, при наличии хотя бы одной ошибки (Operation?)
        }
    }
    
    
    func addNewLifeCycle(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.addNewWake(new: lifeCycle, at: date, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.addNewDream(new: lifeCycle, at: date, callback: callback)
        default:
            print("Error! func addNewLifeCycle()")
        }
    }
    
    func changeLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.changeWake(lifeCycle, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.changeDream(lifeCycle, callback: callback)
        default:
            print("Error! func changeLifeCycle()")
        }
    }
    
    
    func deleteLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.deleteWake(lifeCycle, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.deleteDream(lifeCycle, callback: callback)
        default:
            print("Error!  func deleteLifeCycle()")
        }
    }
    
    
}

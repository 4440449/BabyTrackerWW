//
//  PersistenceRepositoryGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 29.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol PersistenceRepositoryProtocol {
    
    func synchronize(lifeCycle: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func change(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
}



final class PersistenceRepositoryGateway: PersistenceRepositoryProtocol {
    
    
    private let wakeRepository: WakePersistenceRepositoryProtocol
    private let dreamRepository: DreamPersistenceRepositoryProtocol
    
    init(wakeRepository: WakePersistenceRepositoryProtocol, dreamRepository: DreamPersistenceRepositoryProtocol) {
        self.wakeRepository = wakeRepository
        self.dreamRepository = dreamRepository
    }
    
    
    struct PersistenceRepositoryError: Error {
        var description = [String]()
        // Объединить или убрать эту ошибку
    }
    
    
    // MARK: - Protocol Implements
    
    func synchronize(lifeCycle: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        
        //Оттестить значения, если в одном из придет нил, проинитится пустой массив? Вообще безопасная конструкция?
        let dreams = lifeCycle.compactMap { $0 as? Dream }
        let wakes = lifeCycle.compactMap { $0 as? Wake }
        
        var resultError = PersistenceRepositoryError()
        
        let serialQ = DispatchQueue.init(label: "localStorageSerialQ")
        serialQ.async {
            
            self.wakeRepository.synchronize(wakes: wakes, date: date) { result in
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
    
    // В текущей логике пока что не использую fetch() из локального хранилища
    func fetchLifeCycle(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) {
        
        var resultError = PersistenceRepositoryError()
        var resultSuccess = [LifeCycle]()
        
        let serialQ = DispatchQueue.init(label: "serialQ")
        serialQ.async {
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
                callback(.success(resultSuccess))
            }
            // TODO: Более красиво обработать остановку задачи, при наличии хотя бы одной ошибки (Operation?)
        }
    }
    
    
    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.addNewWake(new: lifeCycle, at: date, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.addNewDream(new: lifeCycle, at: date, callback: callback)
        default: callback(.failure(LocalStorageError.downcasting("Error downcasting! Unexpected input type / func localStorage.add(new: LifeCycle)")))
        }
    }
    
    
    func change(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.changeWake(lifeCycle, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.changeDream(lifeCycle, callback: callback)
        default: callback(.failure(LocalStorageError.downcasting("Error downcasting! Unexpected input type / func localStorage.change(_: LifeCycle)")))
        }
    }
    
    
    func delete(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ()) {
        switch lifeCycle {
        case let lifeCycle as Wake: self.wakeRepository.deleteWake(lifeCycle, callback: callback)
        case let lifeCycle as Dream: self.dreamRepository.deleteDream(lifeCycle, callback: callback)
        default: callback(.failure(LocalStorageError.downcasting("Error downcasting! Unexpected input type / func localStorage.delete(_: LifeCycle)")))
        }
    }

}


//    func saveData<T>(date: Date, data: T, callback: @escaping (Result<T, Error>) -> ()) where T : LifeCycle {
//
//        CoreDataStackImpl.shared.persistentContainer.performBackgroundTask { (backContext) in
//            var calendar = Calendar.init(identifier: .gregorian)
//            calendar.timeZone = TimeZone.current
//            let startOfDay = calendar.startOfDay(for: date)
//            let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
//
//            let dbRequest = NSFetchRequest<NSFetchRequestResult>(entityName: data.title)
//            dbRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as NSDate, endOfDay as NSDate)
//            do {
//                let fetchResult = try backContext.fetch(dbRequest)
//                let entities = fetchResult
//                callback(.success(wakes))
//            } catch let error {
//                callback(.failure(error))
//            }
//        }
//    }

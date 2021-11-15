//
//  PersistenceStorageManager.swift
//  Baby tracker
//
//  Created by Max on 29.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import CoreData


protocol DreamPersistenceRepositoryProtocol {
    func synchronize(dreams: [Dream], date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func fetchDreams(at date: Date, callback: @escaping (Result<[Dream], Error>) -> ())
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func change(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
    
    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
}



// TODO: - Разобраться с таймс зоной
final class DreamPersistenceRepositoryImpl: DreamPersistenceRepositoryProtocol {
    
    private let coreDataContainer = CoreDataStackImpl.shared.persistentContainer
    
    // MARK: - Private
    
    private func dateInterval(with date: Date) -> (Date, Date) {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
        return (startOfDay, endOfDay)
    }
    
    
    // MARK: - Protocol Implements
    
    func fetchDreams(at date: Date, callback: @escaping (Result<[Dream], Error>) -> ()) {
        let days: (Date, Date) = dateInterval(with: date)
        let request: NSFetchRequest = DreamDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            //                sleep(4)
            let dreams = fetchResult.map { $0.parseToDomain() }
            // self.parseToDomainEntity(dbEntity: $0) } // memory ref?
            callback(.success(dreams))
        } catch let error {
            callback(.failure(LocalStorageError.fetch(error.localizedDescription)))
        }
    }
    
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        //        coreDataContainer.performBackgroundTask { backgroundContext in
        let dbEntity = DreamDBEntity.init(context: coreDataContainer.viewContext)
        dbEntity.populateEntityWithDate(dream: dream, date: date)
        //            print(dbEntity.date!)
        do {
            try coreDataContainer.viewContext.save()
            callback(.success(()))
        } catch let error {
            callback(.failure(LocalStorageError.add(error.localizedDescription)))
        }
        //        }
    }
    
    
    func change(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        //        coreDataContainer.performBackgroundTask { backgroundContext in
        let request: NSFetchRequest = DreamDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", dream.id as NSUUID)
        do {
            if let result = try coreDataContainer.viewContext.fetch(request).first {
                result.populateEntity(dream: dream)
                try coreDataContainer.viewContext.save()
                callback(.success(()))
            }
        } catch let error {
            callback(.failure(LocalStorageError.change(error.localizedDescription)))
        }
        //        }
    }
    
    
    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        //        coreDataContainer.performBackgroundTask { backgroundContext in
        let request: NSFetchRequest = DreamDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", dream.id as NSUUID)
        do {
            if let result = try coreDataContainer.viewContext.fetch(request).first {
                coreDataContainer.viewContext.delete(result)
                try coreDataContainer.viewContext.save()
                callback(.success(()))
            }
        } catch let error {
            callback(.failure(LocalStorageError.delete(error.localizedDescription)))
        }
        //        }
    }
    
    
    func synchronize(dreams: [Dream], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        //            coreDataContainer.performBackgroundTask { backgroundContext in
        let days: (Date, Date) = dateInterval(with: date)
        let request: NSFetchRequest = DreamDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
//            print("fetchResult ================= \(fetchResult)")
            fetchResult.forEach { coreDataContainer.viewContext.delete($0) }
            let emptyDBArray = dreams.map { _ in DreamDBEntity.init(context: coreDataContainer.viewContext) }
//            print("Debug: dream emptyDBArray == \(emptyDBArray) -///- count = \(emptyDBArray.count)")
            for i in 0..<dreams.count {
                emptyDBArray[i].populateEntityWithDate(dream: dreams[i], date: date)
            }
//            print("Debug: dream populateDBArray == \(emptyDBArray) -///- count = \(emptyDBArray.count)")
            try coreDataContainer.viewContext.save()
            callback(.success(()))
        } catch let error {
            callback(.failure(LocalStorageError.synchronize(error.localizedDescription)))
        }
    }
        
}
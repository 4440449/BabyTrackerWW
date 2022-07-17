//
//  DreamPersistentRepository_BTWW.swift
//  Baby tracker
//
//  Created by Max on 29.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import CoreData


protocol DreamPersistentRepositoryProtocol_BTWW {
    func fetchDreams(at date: Date, callback: (Result<[Dream], Error>) -> ())
    func update(_ dreams: [Dream], at date: Date, callback: (Result<Void, Error>) -> ())
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func change(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
}



final class DreamPersistentRepository_BTWW: DreamPersistentRepositoryProtocol_BTWW {
    
    private let coreDataContainer = CoreDataStack_BTWW.shared.persistentContainer
    
    // MARK: - Private
    
    private func dateInterval(with date: Date) -> (Date, Date) {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
        return (startOfDay, endOfDay)
    }
    
    
    // MARK: - Protocol Implementation
    
    func fetchDreams(at date: Date, callback: (Result<[Dream], Error>) -> ()) {
        let days: (Date, Date) = dateInterval(with: date)
        let request: NSFetchRequest = DreamDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            let dreams = try fetchResult.map { try $0.parseToDomainEntity() }
            callback(.success(dreams))
        } catch let error {
            callback(.failure(LocalStorageError.fetch(error)))
        }
    }
    
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let dbEntity = DreamDBEntity.init(context: backgroundContext)
            dbEntity.parseToDBEntityWithDate(dream: dream, date: date)
            //            print(dbEntity.date!)
            do {
                try backgroundContext.save()
                callback(.success(()))
            } catch let error {
                callback(.failure(LocalStorageError.add(error)))
            }
        }
    }
    
    
    func change(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest = DreamDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", dream.id as NSUUID)
            do {
                if let result = try backgroundContext.fetch(request).first {
                    result.parseToDBEntity(dream: dream)
                    try backgroundContext.save()
                    callback(.success(()))
                }
            } catch let error {
                callback(.failure(LocalStorageError.change(error)))
            }
        }
    }
    
    
    func delete(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest = DreamDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", dream.id as NSUUID)
            do {
                if let result = try backgroundContext.fetch(request).first {
                    backgroundContext.delete(result)
                    try backgroundContext.save()
                    callback(.success(()))
                }
            } catch let error {
                callback(.failure(LocalStorageError.delete(error)))
            }
        }
    }
    
    
    func update(_ dreams: [Dream], at date: Date, callback: (Result<Void, Error>) -> ()) {
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
                emptyDBArray[i].parseToDBEntityWithDate(dream: dreams[i], date: date)
            }
            //            print("Debug: dream populateDBArray == \(emptyDBArray) -///- count = \(emptyDBArray.count)")
            try coreDataContainer.viewContext.save()
            callback(.success(()))
        } catch let error {
            callback(.failure(LocalStorageError.synchronize(error)))
        }
    }
    
}

//
//  WakePersistentRepository_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 29.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import CoreData


protocol WakePersistentRepositoryProtocol_BTWW {
    
    func fetchWakes(at date: Date, callback: (Result<[Wake], Error>) -> ())
    func update(wakes: [Wake], date: Date, callback: (Result<Void, Error>) -> ())
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func change(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ())
    func delete(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ())
}


final class WakePersistentRepository_BTWW: WakePersistentRepositoryProtocol_BTWW {
    
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
    
    func fetchWakes(at date: Date, callback: (Result<[Wake], Error>) -> ()) {
        
        let days: (Date, Date) = dateInterval(with: date)
        
        let request: NSFetchRequest = WakeDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            let wakes = try fetchResult.map { try $0.parseToDomain() }
            callback(.success(wakes))
        } catch let error {
            callback(.failure(LocalStorageError.fetch(error)))
        }
    }
    
    
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let dbEntity = WakeDBEntity.init(context: backgroundContext)
            dbEntity.populateEntityWithDate(wake: wake, date: date)
            do {
                try backgroundContext.save()
                callback(.success(()))
            } catch let error {
                callback(.failure(LocalStorageError.add(error)))
            }
        }
    }
    
    
    func change(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest = WakeDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", wake.id as NSUUID)
            do {
                if let result = try backgroundContext.fetch(request).first {
                    result.populateEntity(wake: wake)
                    try backgroundContext.save()
                    callback(.success(()))
                }
            } catch let error {
                callback(.failure(LocalStorageError.change(error)))
            }
        }
    }
    
    
    func delete(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest = WakeDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", wake.id as NSUUID)
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
    
    
    func update(wakes: [Wake], date: Date, callback: (Result<Void, Error>) -> ()) {
        //        coreDataContainer.performBackgroundTask { backgroundContext in
        let days: (Date, Date) = self.dateInterval(with: date)
        let request: NSFetchRequest = WakeDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            fetchResult.forEach { coreDataContainer.viewContext.delete($0) }
            let emptyDBArray = wakes.map { _ in WakeDBEntity.init(context: coreDataContainer.viewContext) }
            for i in 0..<emptyDBArray.count {
                emptyDBArray[i].populateEntityWithDate(wake: wakes[i], date: date)
            }
            try coreDataContainer.viewContext.save()
            callback(.success(()))
        } catch let error {
            callback(.failure(LocalStorageError.synchronize(error)))
        }
    }
    
    
}

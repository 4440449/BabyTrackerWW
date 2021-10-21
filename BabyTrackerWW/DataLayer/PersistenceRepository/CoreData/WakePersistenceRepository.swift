//
//  WakeRepository.swift
//  BabyTrackerWW
//
//  Created by Max on 29.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import CoreData


final class WakePersistenceRepositoryImpl: WakeGatewayProtocol {
    
    private let coreDataContainer = CoreDataStackImpl.shared.persistentContainer
    
    // MARK: - Private
    
    
    private func parseToDomainEntity(dbEntity: WakeDBEntity) -> Wake {
        return .init(    id: dbEntity.id!,
                         index: Int(dbEntity.index),
                         wakeUp: Wake.WakeUp(rawValue: dbEntity.wakeUp!)!,
                         wakeWindow: Wake.WakeWindow(rawValue: dbEntity.wakeWindow!)!,
                         signs: Wake.Signs(rawValue: dbEntity.signs!)! )
    }
    
    private func dateInterval(with date: Date) -> (Date, Date) {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
        return (startOfDay, endOfDay)
    }
    
    private func parse(date: Date, wake: [Wake], dbWake: inout [WakeDBEntity]) {
        for db in dbWake {
            for w in wake {
                db.populateEntityWithDate(wake: w, date: date)
            }
        }
    }
    
    // MARK: - Protocol Implements
    
    func fetchWakes(at date: Date, callback: @escaping (Result<[Wake], Error>) -> ()) {

        let days: (Date, Date) = dateInterval(with: date)
        
        let request: NSFetchRequest = WakeDBEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
        do {
            let fetchResult = try coreDataContainer.viewContext.fetch(request)
            let wakes = fetchResult.map { self.parseToDomainEntity(dbEntity: $0) } // memory ref?
            callback(.success(wakes))
        } catch let error {
            callback(.failure(error))
        }
    }
    
    
    func addNewWake(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let dbEntity = WakeDBEntity.init(context: backgroundContext)
            dbEntity.populateEntityWithDate(wake: wake, date: date)
            do {
                try backgroundContext.save()
                callback(.success(()))
            } catch let error {
                callback(.failure(error))
            }
        }
    }
    
    
    func changeWake(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
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
                callback(.failure(error))
            }
        }
    }
    
    
    func deleteWake(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
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
                callback(.failure(error))
            }
        }
    }
    
    
    
    func synchronize(wakes: [Wake], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            // посмотреть утечки!
            let days: (Date, Date) = self.dateInterval(with: date)
            let request: NSFetchRequest = WakeDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
            do {
                let fetchResult = try backgroundContext.fetch(request)
                fetchResult.forEach { backgroundContext.delete($0) }
                
                let emptyDBArray = wakes.map { _ in WakeDBEntity.init(context: backgroundContext) }
                print("Debug: emptyDBArray = \(emptyDBArray) -///- count = \(emptyDBArray.count)")
                emptyDBArray.forEach { db in wakes.forEach { wake in db.populateEntityWithDate(wake: wake, date: date)} } // Смущает, что ругается о неизменности массива, хотя я его меняю. Если не будет работать, попробовать свой метод с ссылкой в аргементе
//                self.parse(date: date, wake: wakes, dbWake: &emptyDBArray)
                print("Debug: emptyDBArray = \(emptyDBArray) -///- count = \(emptyDBArray.count)")
                
                try backgroundContext.save()
                callback(.success(()))
            } catch let error {
                callback(.failure(error))
            }
        }
    }
    
    
}

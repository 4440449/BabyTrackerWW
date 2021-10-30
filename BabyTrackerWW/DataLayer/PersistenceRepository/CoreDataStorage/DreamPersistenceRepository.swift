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
    func addNewDream(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func changeDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
}



// TODO: - Разобраться с таймс зоной
final class DreamPersistenceRepositoryImpl: DreamPersistenceRepositoryProtocol {
    
//        struct ErrorTest: Error {}

    private let coreDataContainer = CoreDataStackImpl.shared.persistentContainer
    
    // MARK: - Private
    
    private func parseToDomainEntity(dbEntity: DreamDBEntity) -> Dream {
        return .init(    id: dbEntity.id!,
                         index: Int(dbEntity.index),
                         putDown: Dream.PutDown(rawValue: dbEntity.putDown!)!,
                         fallAsleep: Dream.FallAsleep(rawValue: dbEntity.fallAsleep!)!)
    }
    
    
    private func dateInterval(with date: Date) -> (Date, Date) {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
        return (startOfDay, endOfDay)
    }
    
    
    private func parse(date: Date, dreams: [Dream], dbDream: inout [DreamDBEntity]) {
           for db in dbDream {
               for d in dreams {
                   db.populateEntityWithDate(dream: d, date: date)
                   // Не работает! Первый цикл проходит одним элементом по каждому из второго цикла
               }
           }
       }
    
    
    // MARK: - Protocol Implements
    
    func fetchDreams(at date: Date, callback: @escaping (Result<[Dream], Error>) -> ()) {
        
            var calendar = Calendar.init(identifier: .gregorian)
            calendar.timeZone = TimeZone.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .hour, value: 24, to: startOfDay)!
//            print("startOfDay = \(startOfDay), endOfDay = \(endOfDay)")
            
            let request: NSFetchRequest = DreamDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as NSDate, endOfDay as NSDate)
            do {
                let fetchResult = try coreDataContainer.viewContext.fetch(request)
//                sleep(4)
                let dreams = fetchResult.map { self.parseToDomainEntity(dbEntity: $0) } // memory ref?
//                print(dreams.map { $0.index })
                callback(.success(dreams))
//                callback(.failure(ErrorTest()))
                
            } catch let error {
                callback(.failure(LocalStorageError.fetch(error.localizedDescription)))
            }
    }
    
    
    func addNewDream(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let dbEntity = DreamDBEntity.init(context: backgroundContext)
            dbEntity.populateEntityWithDate(dream: dream, date: date)
//            print(dbEntity.date!)
            do {
                try backgroundContext.save()
                callback(.success(()))
            } catch let error {
                callback(.failure(LocalStorageError.add(error.localizedDescription)))
            }
        }
    }
    
    
    func changeDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        coreDataContainer.performBackgroundTask { backgroundContext in
            let request: NSFetchRequest = DreamDBEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", dream.id as NSUUID)
            do {
                if let result = try backgroundContext.fetch(request).first {
                    result.populateEntity(dream: dream)
                    try backgroundContext.save()
                    callback(.success(()))
                }
            } catch let error {
                callback(.failure(LocalStorageError.change(error.localizedDescription)))
            }
        }
    }
    
    
    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
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
                callback(.failure(LocalStorageError.delete(error.localizedDescription)))
            }
        }
    }
    
       func synchronize(dreams: [Dream], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
            coreDataContainer.performBackgroundTask { backgroundContext in
                // посмотреть утечки!
                let days: (Date, Date) = self.dateInterval(with: date)
                let request: NSFetchRequest = DreamDBEntity.fetchRequest()
                request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", days.0 as NSDate, days.1 as NSDate)
                do {
                    let fetchResult = try backgroundContext.fetch(request)
                    fetchResult.forEach { backgroundContext.delete($0) }
                    
                    let emptyDBArray = dreams.map { _ in DreamDBEntity.init(context: backgroundContext) }
                    print("Debug: dream emptyDBArray == \(emptyDBArray) -///- count = \(emptyDBArray.count)")
                    emptyDBArray.forEach { db in dreams.forEach { dream in db.populateEntityWithDate(dream: dream, date: date)} } // Смущает, что ругается о неизменности массива, хотя я его меняю. Если не будет работать, попробовать свой метод с ссылкой в аргементе
    //                self.parse(date: date, wake: wakes, dbWake: &emptyDBArray)
                    print("Debug: dream emptyDBArray == \(emptyDBArray) -///- count = \(emptyDBArray.count)")
                    
                    try backgroundContext.save()
                    callback(.success(()))
                } catch let error {
                    callback(.failure(LocalStorageError.synchronize(error.localizedDescription)))
                }
            }
        }
    
}

//
//  PersistenceStorageManager.swift
//  Baby tracker
//
//  Created by Max on 29.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import CoreData


// TODO: - Разобраться с таймс зоной
final class DreamPersistenceRepositoryImpl: DreamGatewayProtocol {
    
//        struct ErrorTest: Error {}

    private let coreDataContainer = CoreDataStackImpl.shared.persistentContainer
    
    // MARK: - Private
    
    private func parseToDomainEntity(dbEntity: DreamDBEntity) -> Dream {
        return .init(    id: dbEntity.id!,
                         index: Int(dbEntity.index),
                         putDown: Dream.PutDown(rawValue: dbEntity.putDown!)!,
                         fallAsleep: Dream.FallAsleep(rawValue: dbEntity.fallAsleep!)!)
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
                callback(.failure(error))
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
                callback(.failure(error))
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
                callback(.failure(error))
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
                callback(.failure(error))
            }
        }
    }
}

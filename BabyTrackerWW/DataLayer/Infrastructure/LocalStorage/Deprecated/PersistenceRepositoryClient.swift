//
//  PersistenceRepositoryClient.swift
//  BabyTrackerWW
//
//  Created by Max on 28.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

//import Foundation
//import CoreData
//
//
//final class PersistenceRepositoryClient {
//
//
//    func fetch<T : NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) throws -> [T] {
//
//        let request = NSFetchRequest<T>(entityName: T.description())
//        request.predicate = predicate
//        let results = try
//    }
//
//
//
//    func add() { }
//
//}
//import Foundation
//import CoreData
//
//
//protocol PersistenceRepositoryClientProtocol {
//
//    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
//    func change(current lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
//    func delete(_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
//}
//
//final class PersistenceRepositoryClientImpl: PersistenceRepositoryClientProtocol {
//
//
//    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
//
//        guard let desc = NSEntityDescription.entity(forEntityName: lifeCycle.title, in: CoreDataStackImpl.shared.persistentContainer.viewContext) else { return }
//        let dbEntity = NSManagedObject(entity: desc, insertInto: CoreDataStackImpl.shared.persistentContainer.viewContext)
//        dbEntity.populateEntityWithDate(domain: lifeCycle, date: date)
//
//    }
//
//    func change(current lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
//        <#code#>
//    }
//
//    func delete(_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
//        <#code#>
//    }
//
//
//}
//
//protocol Populate {
////    associatedtype T: LifeCycle
//    func populateEntityWithDate<T>(domain entity: T, date: Date)
//}
//
//extension NSManagedObject {
//
//    func populateEntityWithDate<T>(domain entity: T, date: Date) {
//        <#code#>
//    }
//
//
//    func populateEntityWithDate<T: LifeCycle>(domain entity: T, date: Date) {}
//
//}

//
//  DreamDBEntity+CoreDataProperties.swift
//  Baby tracker
//
//  Created by Max on 29.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//
//

import Foundation
import CoreData


extension DreamDBEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DreamDBEntity> {
        return NSFetchRequest<DreamDBEntity>(entityName: "DreamDBEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var index: Int32
    @NSManaged public var putDown: String?
    @NSManaged public var fallAsleep: String?
    @NSManaged public var note: String?
}


extension DreamDBEntity {
    
    func parseToDBEntity(dream: Dream) {
        index = Int32(dream.index)
        putDown = dream.putDown
        fallAsleep = dream.fallAsleep
        note = dream.note
    }
    
    func parseToDBEntityWithDate(dream: Dream, date: Date) {
        self.date = date
        id = dream.id
        index = Int32(dream.index)
        putDown = dream.putDown
        fallAsleep = dream.fallAsleep
        note = dream.note
    }
    
    func parseToDomainEntity() throws -> Dream {
        //Вместо nil, index default == некорректному значению; Т.к. Objc не видит Type: (Int32?)
        guard index != -1,
            let index = Int(exactly: index),
            let id = id,
            let putDownRawValue = putDown,
            let putDown = Dream.PutDown.init(rawValue: putDownRawValue),
            let fallAsleepRawValue = fallAsleep,
            let fallAsleep = Dream.FallAsleep(rawValue: fallAsleepRawValue),
            let note = note
            else { throw LocalStorageError.parseToDomain("Error parse to domain DreamDBEntity!") }
        return .init(id: id,
                     index: index,
                     putDown: putDown,
                     fallAsleep: fallAsleep,
                     note: note)
    }
    
}


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
    
    func populateEntity(dream: Dream) {
        self.index = Int32(dream.index)
        self.putDown = dream.putDown
        self.fallAsleep = dream.fallAsleep
        self.note = dream.note
    }
    
    func populateEntityWithDate(dream: Dream, date: Date) {
        self.date = date
        self.id = dream.id
        self.index = Int32(dream.index)
        self.putDown = dream.putDown
        self.fallAsleep = dream.fallAsleep
        self.note = dream.note
    }
    
    // TODO: - сделать throws и хендлинг ошибки парсинга в доменную сущность
    func parseToDomain() -> Dream {
        return .init(id: self.id!,
                     index: Int(self.index),
                     putDown: Dream.PutDown(rawValue: self.putDown!)!,
                     fallAsleep: Dream.FallAsleep(rawValue: self.fallAsleep!)!,
                     note: self.note!)
    }
    
}


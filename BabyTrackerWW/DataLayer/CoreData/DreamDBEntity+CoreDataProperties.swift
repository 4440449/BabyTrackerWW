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

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var putDown: String?
    @NSManaged public var fallAsleep: String?
    @NSManaged public var wakeUp: String?
}


extension DreamDBEntity {
    
    func populateEntity(dream: Dream) {
        self.putDown = dream.putDown.rawValue
        self.fallAsleep = dream.fallAsleep.rawValue
        self.wakeUp = dream.wakeUp.rawValue
    }
    
    func populateEntityWithDate(dream: Dream, date: Date) {
        self.date = date
        self.id = dream.id
        self.putDown = dream.putDown.rawValue
        self.fallAsleep = dream.fallAsleep.rawValue
        self.wakeUp = dream.wakeUp.rawValue
    }
    
}

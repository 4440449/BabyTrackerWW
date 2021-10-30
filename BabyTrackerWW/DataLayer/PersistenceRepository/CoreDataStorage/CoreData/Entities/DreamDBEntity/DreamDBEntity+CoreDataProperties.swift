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
    //    @NSManaged public var wakeUp: String?
}


extension DreamDBEntity {
    
    //TEST
    convenience init(domainEntity: Dream) {
        self.init()
        self.index = Int32(domainEntity.index)
        self.putDown = domainEntity.putDown
        self.fallAsleep = domainEntity.fallAsleep
    }
    //TEST
    
    func populateEntity(dream: Dream) {
        self.index = Int32(dream.index)
        self.putDown = dream.putDown
        self.fallAsleep = dream.fallAsleep
        //        self.wakeUp = dream.wakeUp.rawValue
    }
    
    func populateEntityWithDate(dream: Dream, date: Date) {
        self.date = date
        self.id = dream.id
        self.index = Int32(dream.index)
        self.putDown = dream.putDown
        self.fallAsleep = dream.fallAsleep
        //        self.wakeUp = dream.wakeUp.rawValue
    }
    
}

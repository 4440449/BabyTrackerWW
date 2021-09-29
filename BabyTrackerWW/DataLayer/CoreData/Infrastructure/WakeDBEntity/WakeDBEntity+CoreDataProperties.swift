//
//  WakeDBEntity+CoreDataProperties.swift
//  BabyTrackerWW
//
//  Created by Max on 29.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//
//

import Foundation
import CoreData


extension WakeDBEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WakeDBEntity> {
        return NSFetchRequest<WakeDBEntity>(entityName: "WakeDBEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var index: Int32
    @NSManaged public var date: Date?
    @NSManaged public var wakeUp: String?
    @NSManaged public var wakeWindow: String?
    @NSManaged public var signs: String?
}

extension WakeDBEntity {
    
    func populateEntity(wake: Wake) {
        self.index = Int32(wake.index)
        self.wakeUp = wake.wakeUp.rawValue
        self.wakeWindow = wake.wakeWindow.rawValue
        self.signs = wake.signs.rawValue
    }
    
    func populateEntityWithDate(wake: Wake, date: Date) {
        self.id = wake.id
        self.date = date
        self.index = Int32(wake.index)
        self.wakeUp = wake.wakeUp.rawValue
        self.wakeWindow = wake.wakeWindow.rawValue
        self.signs = wake.signs.rawValue
    }
}

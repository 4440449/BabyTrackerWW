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
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var index: Int32
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
        self.date = date
        self.id = wake.id
        self.index = Int32(wake.index)
        self.wakeUp = wake.wakeUp.rawValue
        self.wakeWindow = wake.wakeWindow.rawValue
        self.signs = wake.signs.rawValue
    }
    
    // TODO: - сделать throws и хендлинг ошибки парсинга в доменную сущность
    func parseToDomain() -> Wake {
        return .init(id: self.id!,
                     index: Int(self.index),
                     wakeUp: Wake.WakeUp(rawValue: self.wakeUp!)!,
                     wakeWindow: Wake.WakeWindow(rawValue: self.wakeWindow!)!,
                     signs: Wake.Signs(rawValue: self.signs!)!)
    }
}

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
    @NSManaged public var note: String?
}

extension WakeDBEntity {
    
    func populateEntity(wake: Wake) {
        self.index = Int32(wake.index)
        self.wakeUp = wake.wakeUp.rawValue
        self.wakeWindow = wake.wakeWindow.rawValue
        self.signs = wake.signs.rawValue
        self.note = wake.note
    }
    
    func populateEntityWithDate(wake: Wake, date: Date) {
        self.date = date
        self.id = wake.id
        self.index = Int32(wake.index)
        self.wakeUp = wake.wakeUp.rawValue
        self.wakeWindow = wake.wakeWindow.rawValue
        self.signs = wake.signs.rawValue
        self.note = wake.note
    }
    
    func parseToDomain() throws -> Wake {
        //Вместо nil, index default == некорректному значению; Т.к. Objc не видит Type: (Int32?)
        guard index != -1,
            let index = Int(exactly: index),
            let id = id,
            let wakeUpRawValue = wakeUp,
            let wakeUp = Wake.WakeUp(rawValue: wakeUpRawValue),
            let wakeWindowRawValue = wakeWindow,
            let wakeWindow = Wake.WakeWindow(rawValue: wakeWindowRawValue),
            let signsRawValue = signs,
            let signs = Wake.Signs(rawValue: signsRawValue),
            let note = note
            else { throw LocalStorageError.parseToDomain("Error parse to domain WakeDBEntity!") }
        return .init(id: id,
                     index: index,
                     wakeUp: wakeUp,
                     wakeWindow: wakeWindow,
                     signs: signs,
                     note: note)
    }
}

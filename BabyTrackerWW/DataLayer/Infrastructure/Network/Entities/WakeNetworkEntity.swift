//
//  WakeNetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 25.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


struct WakeNetworkEntity: Codable {
    
    private let date: String
    let id: UUID
    let index: Int
    let wakeUp: String
    let wakeWindow: String
    let signs: String
    let note: String
    
    enum CodingKeys: CodingKey {
        case date
        case id
        case index
        case wakeUp
        case wakeWindow
        case signs
        case note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.index = try container.decode(Int.self, forKey: .index)
        self.wakeUp = try container.decode(String.self, forKey: .wakeUp)
        self.wakeWindow = try container.decode(String.self, forKey: .wakeWindow)
        self.signs = try container.decode(String.self, forKey: .signs)
        self.note = try container.decode(String.self, forKey: .note)
    }
    
    init(domainEntity: Wake, date: String) {
        self.date = date
        self.id = domainEntity.id
        self.index = domainEntity.index
        self.wakeUp = domainEntity.wakeUp.rawValue
        self.wakeWindow = domainEntity.wakeWindow.rawValue
        self.signs = domainEntity.signs.rawValue
        self.note = domainEntity.note
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(wakeUp, forKey: .wakeUp)
        try container.encode(wakeWindow, forKey: .wakeWindow)
        try container.encode(signs, forKey: .signs)
        try container.encode(note, forKey: .note)
    }
    
    
    func parseToDomain() throws -> Wake {
        
        guard let wakeUp = Wake.WakeUp.init(rawValue: self.wakeUp),
            let wakeWindow = Wake.WakeWindow.init(rawValue: self.wakeWindow),
            let signs = Wake.Signs.init(rawValue: self.signs)
        else { throw BabyNetError.parseToDomain("Error parseToDomain(Wake)") }
        
        return .init (id: self.id,
                      index: self.index,
                      wakeUp: wakeUp,
                      wakeWindow: wakeWindow,
                      signs: signs,
                      note: self.note)
    }
}

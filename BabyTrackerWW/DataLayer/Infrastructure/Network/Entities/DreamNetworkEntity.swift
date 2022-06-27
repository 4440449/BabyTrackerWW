//
//  NetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 25.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


struct DreamNetworkEntity: Codable {
    
    private let date: String
    let id: UUID
    let index: Int
    let fallAsleep: String
    let putDown: String
    let note: String
    
    enum CodingKeys: CodingKey {
        case date
        case id
        case index
        case fallAsleep
        case putDown
        case note
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.index = try container.decode(Int.self, forKey: .index)
        self.fallAsleep = try container.decode(String.self, forKey: .fallAsleep)
        self.putDown = try container.decode(String.self, forKey: .putDown)
        self.note = try container.decode(String.self, forKey: .note)
    }
    
    init(domainEntity: Dream, date: String) {
        self.date = date
        self.id = domainEntity.id
        self.index = domainEntity.index
        self.fallAsleep = domainEntity.fallAsleep
        self.putDown = domainEntity.putDown
        self.note = domainEntity.note
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(fallAsleep, forKey: .fallAsleep)
        try container.encode(putDown, forKey: .putDown)
        try container.encode(note, forKey: .note)
    }
    
    
    func parseToDomain() throws -> Dream {
        guard let fallAsleep = Dream.FallAsleep.init(rawValue: self.fallAsleep),
              let putDown = Dream.PutDown.init(rawValue: self.putDown)
        else { throw BabyNetError.parseToDomain("Error parseToDomain(Dream)") }
        return .init (id: self.id,
                      index: self.index,
                      putDown: putDown,
                      fallAsleep: fallAsleep,
                      note: self.note)
    }
    
}


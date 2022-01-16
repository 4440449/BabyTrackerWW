//
//  JsonPatchEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 02.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct JsonPatchEntity_BTWW: Encodable {
    let op: String
    let path: String
    let lifeCycles: LifeCycleNetworkEntity
    
    enum PatchOperation: String {
        case add = "add"
        case remove = "remove"
        case replace = "replace"
        case move = "move"
        case copy = "copy"
        case test = "test"
    }
    
    enum CodingKeys: CodingKey {
        case op
        case path
        case lifeCycles
    }
    
    
    init(op: PatchOperation, path: String, values: LifeCycleNetworkEntity) {
        self.op = op.rawValue
        self.path = path
        self.lifeCycles = values
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(op, forKey: .op)
        try container.encode(path, forKey: .path)
        try container.encode(lifeCycles, forKey: .lifeCycles)
       }
    
}



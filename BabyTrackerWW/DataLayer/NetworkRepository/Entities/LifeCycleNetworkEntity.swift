//
//  LifeCycleNetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 26.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct LifeCycleNetworkEntity: Codable {
    
    var dreams: [DreamNetworkEntity] = []
    var wakes: [WakeNetworkEntity] = []
    
    func parseToDomain() throws -> [LifeCycle] {
        let dreamDomain = try dreams.map { try $0.parseToDomain() }
        let wakeDomain = try wakes.map { try $0.parseToDomain() }
        let lc: [LifeCycle] = dreamDomain + wakeDomain
        return lc
    }
}



//struct Items: Codable {
//    var lc: [LifeCycleNetworkEntity] = []
//}

//
//  LifeCycleNetworkEntity.swift
//  BabyTrackerWW
//
//  Created by Max on 26.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import BabyNet


struct LifeCycleNetworkEntity: Codable {
    
    var dreams: [DreamNetworkEntity]?
    var wakes: [WakeNetworkEntity]?
    
    enum CodingKeys: CodingKey {
        case dreams
        case wakes
    }
    
    init(domainEntity: [LifeCycle], date: Date) {
        let dreams = domainEntity.compactMap { $0 as? Dream }
        let wakes = domainEntity.compactMap { $0 as? Wake }
        if !dreams.isEmpty {
            self.dreams = dreams.map { DreamNetworkEntity(domainEntity: $0, date: date.webApiFormat()) }
        }
        if !wakes.isEmpty {
            self.wakes = wakes.map { WakeNetworkEntity(domainEntity: $0, date: date.webApiFormat()) }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dreams = try container.decode([DreamNetworkEntity].self, forKey: .dreams)
        self.wakes = try container.decode([WakeNetworkEntity].self, forKey: .wakes)
    }
    
    
    func parseToDomain() throws -> [LifeCycle] {
        let dreamDomain = try dreams?.map { try $0.parseToDomain() }
        let wakeDomain = try wakes?.map { try $0.parseToDomain() }
        let lc: [LifeCycle] = (dreamDomain ?? []) + (wakeDomain ?? [])
        return lc
    }

}

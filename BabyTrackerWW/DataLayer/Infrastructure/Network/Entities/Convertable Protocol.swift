//
//  Convertable Protocol.swift
//  BabyTrackerWW
//
//  Created by Max on 20.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//



protocol DomainConvertable {
    associatedtype T
    func parseToDomain() throws -> T
}

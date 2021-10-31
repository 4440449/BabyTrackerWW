//
//  Extensions.swift
//  BabyTrackerWW
//
//  Created by Max on 29.10.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


extension Encodable {
    func jsonEncode() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

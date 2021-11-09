//
//  PresentExtensions.swift
//  BabyTrackerWW
//
//  Created by Max on 10.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

//import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}

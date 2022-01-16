//
//  NetworkRepositoryExtensions_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 03.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

extension Date {
    
    func webApiFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
    
    func urlFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return "eq.\(formatter.string(from: self))"
    }
    
}

//
//  LifeCyclesCard.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct LifeCyclesCard {
    var date: Date
    var lifeCycle: [LifeCycle] = []
    init (date: Date) {
        self.date = date
    }
}

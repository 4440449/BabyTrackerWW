//
//  DreamsCard.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct DreamsCard {
    var date: Date
    var lifeCycle: [LifeCycle] = [] // Здесь должен быть массив абстракций, чтобы работать одним кодом с разными типами
    init (date: Date) {
        self.date = date
    }
}

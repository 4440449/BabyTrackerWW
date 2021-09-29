//
//  Dream.swift
//  Baby tracker
//
//  Created by Max on 11.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct Dream: LifeCycle {
    let id: UUID
    let title = "Сон"
    var index: Int
    var putDown: PutDown
    var fallAsleep: FallAsleep
    var wakeUp: WakeUp
    
    enum PutDown: String, CaseIterable, RawRepresentable, LifeCycleProperty {
        case brestFeeding = "На груди"
        case holding      = "На руках"
        case themSelfs    = "Самостоятельно"
    }
    
    enum FallAsleep: String, CaseIterable, RawRepresentable, LifeCycleProperty {
        case crying = "Плакал"
        case upSet  = "Расстроенный"
        case calm   = "Спокойный"
        case happy  = "Веселый"
    }

    enum WakeUp: String, CaseIterable, RawRepresentable, LifeCycleProperty { // Удалить
        case happy  = "Веселый"
        case crying = "Плакал"
        case upSet  = "Расстроенный"
        case calm   = "Спокойный"
    }

    init (index: Int, putDown: PutDown, fallAsleep: FallAsleep, wakeUp: WakeUp) {
        self.id = UUID()
        self.index = index
        self.putDown = putDown
        self.fallAsleep = fallAsleep
        self.wakeUp = wakeUp
    }
    
    init (id: UUID, index: Int, putDown: PutDown, fallAsleep: FallAsleep, wakeUp: WakeUp) {
        self.id = id
        self.index = index
        self.putDown = putDown
        self.fallAsleep = fallAsleep
        self.wakeUp = wakeUp
    }
}

//
//  Wake.swift
//  BabyTrackerWW
//
//  Created by Max on 10.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct Wake: LifeCycle {
    let id: UUID
    let title = "Бодрствование"
    var index: Int
    var wakeUp: WakeUp
    var wakeWindow: WakeWindow
    var signs: Signs
    var note: String = ""
    
    enum WakeUp: String, CaseIterable, RawRepresentable, LifeCycleProperty {
        //в каком настроении проснулся?
        case crying = "😭"// "Плакал"
        case upSet  = "😒"// "Расстроенный"
        case calm   = "🙂"// "Спокойный"
        case happy  = "🤪"// "Веселый"
    }
    
    enum WakeWindow: String, CaseIterable, RawRepresentable, LifeCycleProperty { // Как прошло бодрствование?
        case fussy = "Капризничал"
        case hold  = "Сидел на руках"
        case calm  = "Спокойно"
        case happy = "Активно"
    }
    
    enum Signs: String, CaseIterable, RawRepresentable, LifeCycleProperty {
        // По каким признакам начала укладывать?
        case crying = "Плакал"
        case hold   = "Сидел на руках"
        case freeze = "Замедлился"
        case custom = "Свой признак"
    }
    
    init(index: Int, wakeUp: WakeUp, wakeWindow: WakeWindow, signs: Signs) {
        self.id = UUID()
        self.index = index
        self.wakeUp = wakeUp
        self.wakeWindow = wakeWindow
        self.signs = signs
    }
    
    init(id: UUID, index: Int, wakeUp: WakeUp, wakeWindow: WakeWindow, signs: Signs, note: String) {
        self.id = id
        self.index = index
        self.wakeUp = wakeUp
        self.wakeWindow = wakeWindow
        self.signs = signs
        self.note = note
    }
    
}

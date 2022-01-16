//
//  LifeCyclesProtocols_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCycle {
    var id : UUID { get }
    var title: String { get }
    var index: Int { get set }
}

protocol LifeCycleProperty {
    
}

//
//  Observer.swift
//  BabyTrackerWW
//
//  Created by Max on 05.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


struct Observer<T> {
    weak var observer: AnyObject?
    let callback: (T) -> ()
    
    init(_ observer: AnyObject?, _ callback: @escaping (T) -> () ) {
        self.callback = callback
        guard observer != nil else { self.observer = nil; return }
        self.observer = observer
    }
    
}

//
//  Observer.swift
//  BabyTrackerWW
//
//  Created by Max on 03.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation



final class Publisher<V> {
    
//    struct Observer<T> {
//        weak var observer: AnyObject?
//        let callback: (T) -> ()
//    }
    
    var value: V { didSet { notify() } }
    private var observers = [Observer<V>]()
    
    init(value: V) {
        self.value = value
    }
    
    private func notify() {
        DispatchQueue.main.async {
            self.observers.forEach { $0.callback(self.value) }
        }
    }
    
    
    func subscribe(observer: AnyObject, callback: @escaping (V) -> ()) {
        observers.append(Observer(observer, callback))
    }
    
    func unsubscribe(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    
}



//
//  Observer.swift
//  BabyTrackerWW
//
//  Created by Max on 03.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation

protocol Observable {
    associatedtype V
    func subscribe(observer: AnyObject, callback: @escaping (V) -> ())
    func unsubscribe(observer: AnyObject)
}


final class Publisher<V>: Observable {
   
    struct Observer<T> {
        weak var observer: AnyObject?
        let callback: (T) -> ()
        
        init(_ observer: AnyObject?, _ callback: @escaping (T) -> () ) {
            self.callback = callback
            guard observer != nil else { self.observer = nil; return }
            self.observer = observer
        }
    }
    
    var value: V { didSet { notify() } }
//        ; print(self, "didSet!", self.value) } }
    private var observers = [Observer<V>]() //{ didSet { print("")}}
    
    init(value: V) {
        self.value = value
    }
    
    private func notify() {
//        print("notify! value == \(value)")
        DispatchQueue.main.async {
            self.observers.forEach { $0.callback(self.value) }
        }
    }
    
    
    func subscribe(observer: AnyObject, callback: @escaping (V) -> ()) {
        observers.append(Observer(observer, callback))
    }
    
    func unsubscribe(observer: AnyObject) {
//        print("Defore", observers)
        observers = observers.filter { $0.observer !== observer }
//        print("After", observers)
    }
    
    deinit {
        print("Publisher is deinit")
    }
}



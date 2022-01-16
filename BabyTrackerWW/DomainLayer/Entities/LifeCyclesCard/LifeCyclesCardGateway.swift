//
//  LifeCyclesCardGateway.swift
//  Baby tracker
//
//  Created by Max on 04.08.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol LifeCyclesCardGateway {
    
    func fetch(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ()) -> Cancellable?
    func update(newValue: [LifeCycle], oldValue: [LifeCycle], date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable?
    
//    func add(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
//    func change(current lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
//    func delete(_ lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
}

//
//  WakeGateway.swift
//  BabyTrackerWW
//
//  Created by Max on 10.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol WakeGateway {

//    func fetchWakes(at date: Date, callback: @escaping (Result<[Wake], Error>) -> ())
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable?
    func change(_ wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable?
//    func deleteWake(_ dream: Wake, callback: @escaping (Result<Void, Error>) -> ())
}

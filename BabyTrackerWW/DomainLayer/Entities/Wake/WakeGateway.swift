//
//  WakeGateway.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 10.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol WakeGatewayProtocol {
    
    func fetchWakes(at date: Date, callback: @escaping (Result<[Wake], Error>) -> ())
    func addNewWake(new dream: Wake, at date: Date, callback: @escaping (Result<Wake, Error>) -> ())
    func changeWake(_ dream: Wake, callback: @escaping (Result<Wake, Error>) -> ())
    func deleteWake(_ dream: Wake, callback: @escaping (Result<Void, Error>) -> ())
}

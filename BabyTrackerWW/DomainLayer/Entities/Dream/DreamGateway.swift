//
//  Use Cases.swift
//  Baby tracker
//
//  Created by Max on 02.08.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DreamGatewayProtocol {

//    func fetchDreams(at date: Date, callback: @escaping (Result<[Dream], Error>) -> ())
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable?
    func change(_ dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) -> Cancellable?
//    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ())
}

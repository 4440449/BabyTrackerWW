//
//  WakePersistentRepositoryMock.swift
//  BabyTrackerWWTests
//
//  Created by Max on 25.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import XCTest
@testable import BabyTrackerWW


class  WakePersistentRepositoryMock: WakePersistentRepositoryProtocol_BTWW {
    
    var wakeResult: (Result<[Wake], Error>)
    var emptyResult: (Result<Void, Error>)
    
    init(dreamResult: (Result<[Wake], Error>), emprtyResult: (Result<Void, Error>)) {
        self.wakeResult = dreamResult
        self.emptyResult = emprtyResult
    }
    
    func fetchWakes(at date: Date, callback: @escaping (Result<[Wake], Error>) -> ()) {
        callback(wakeResult)
    }
    
    func update(wakes: [Wake], date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func add(new wake: Wake, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func change(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func delete(_ wake: Wake, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
}

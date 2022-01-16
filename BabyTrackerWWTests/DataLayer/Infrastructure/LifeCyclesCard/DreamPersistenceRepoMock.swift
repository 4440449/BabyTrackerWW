//
//  DreamPersistentRepositoryMock.swift
//  BabyTrackerWW
//
//  Created by Max on 25.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import XCTest
@testable import BabyTrackerWW


class  DreamPersistentRepositoryMock: DreamPersistentRepositoryProtocol_BTWW {
    
    var dreamResult: (Result<[Dream], Error>)
    var emptyResult: (Result<Void, Error>)
    
    init(dreamResult: (Result<[Dream], Error>), emprtyResult: (Result<Void, Error>)) {
        self.dreamResult = dreamResult
        self.emptyResult = emprtyResult
    }
        
    func fetchDreams(at date: Date, callback: @escaping (Result<[Dream], Error>) -> ()) {
        callback(dreamResult)
    }
    
    func update(_ dreams: [Dream], at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func add(new dream: Dream, at date: Date, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func change(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    func deleteDream(_ dream: Dream, callback: @escaping (Result<Void, Error>) -> ()) {
        callback(emptyResult)
    }
    
    
}

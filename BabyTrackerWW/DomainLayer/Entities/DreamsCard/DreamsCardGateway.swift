//
//  DreamsCardGateway.swift
//  Baby tracker
//
//  Created by Max on 04.08.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DreamsCardGateway {
    
    func fetchLifeCycle(at date: Date, callback: @escaping (Result<[LifeCycle], Error>) -> ())
    func addNewLifeCycle(new lifeCycle: LifeCycle, at date: Date, callback: @escaping (Result<Void, Error>) -> ())
    func changeLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
    func deleteLifeCycle(_ lifeCycle: LifeCycle, callback: @escaping (Result<Void, Error>) -> ())
    
    
    
    
}

//
//  RepositoryTask.swift
//  BabyTrackerWW
//
//  Created by Max on 09.01.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation


protocol Cancellable {
    func cancel()
}


final class RepositoryTask: Cancellable {
    var networkTask: URLSessionTask?
    var isCancelled = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}

//
//  SelectScenePresenter.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//


protocol SelectScenePresenterProtocol: AnyObject {
    func prepare<S>(for segue: S)
}


final class SelectScenePresenterImpl: SelectScenePresenterProtocol {
    
    private let router: SelectSceneRouterProtocol
    private let delegate: SelectSceneDelegate
    
    init(router: SelectSceneRouterProtocol, delegate: SelectSceneDelegate) {
        self.router = router
        self.delegate = delegate
    }
 
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue, delegate: delegate)
    }
        
    deinit {
        print("SelectScenePresenterImpl - is Deinit!")
    }
    
}

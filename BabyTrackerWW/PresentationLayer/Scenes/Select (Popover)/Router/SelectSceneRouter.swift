//
//  SelectSceneRouter.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

//import UIKit
//
//protocol SelectSceneRouterProtocol {
//    func prepare<S,D>(for segue: S, delegate: D)
//}
//
//
//class SelectSceneRouterImpl: SelectSceneRouterProtocol {
//    
//    func prepare<S,D>(for segue: S, delegate: D) {
//        guard let segue = segue as? UIStoryboardSegue else { return }
//        
//        if let vc = segue.destination as? DetailDreamSceneViewController {
//            vc.configurator.configureScene(view: vc, delegate: delegate)
////            vc.presenter.startAddNewFlow(with: Dream.self)
////            vc.presenter.addNewFlow()
//            
//        
//        } else
//        if let vc = segue.destination as? DetailWakeSceneViewController {
//            vc.configurator.configureScene(view: vc, delegate: delegate)
//            vc.presenter.addNewFlow()
//            
//        }
//    }
//    
//    deinit {
////        print("SelectSceneRouterImpl - is Deinit!")
//    }
//    
//}

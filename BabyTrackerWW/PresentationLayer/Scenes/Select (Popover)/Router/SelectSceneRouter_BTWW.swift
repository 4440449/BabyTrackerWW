//
//  SelectSceneRouter_BTWW.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 14.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

//import UIKit
//
//protocol SelectSceneRouterProtocol_BTWW {
//    func prepare<S,D>(for segue: S, delegate: D)
//}
//
//
//class SelectSceneRouter_BTWW: SelectSceneRouterProtocol {
//    
//    func prepare<S,D>(for segue: S, delegate: D) {
//        guard let segue = segue as? UIStoryboardSegue else { return }
//        
//        if let vc = segue.destination as? DetailDreamSceneViewController {
//            vc.configurator.configureScene(view: vc, delegate: delegate)
////            vc.viewModel.startAddNewFlow(with: Dream.self)
////            vc.viewModel.addNewFlow()
//            
//        
//        } else
//        if let vc = segue.destination as? DetailWakeSceneViewController {
//            vc.configurator.configureScene(view: vc, delegate: delegate)
//            vc.viewModel.addNewFlow()
//            
//        }
//    }
//    
//    deinit {
////        print("SelectSceneRouter_BTWW - is Deinit!")
//    }
//    
//}

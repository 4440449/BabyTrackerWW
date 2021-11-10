//
//  DetailDreamSceneRouter.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


protocol DetailDreamSceneRouterProtocol {
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ())
}

//MARK: - Implementation -

final class DetailDreamSceneRouterImpl: DetailDreamSceneRouterProtocol {
    
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ()) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        guard let vc = segue.destination as? PickerViewController else { return }
        
        switch segue {
        case _ where segue.identifier == String.init(describing: Dream.FallAsleep.self): vc.configurator.configureScene(view: vc, type: Dream.FallAsleep.self, callback: callback)
        case _ where segue.identifier == String.init(describing: Dream.PutDown.self): vc.configurator.configureScene(view: vc, type: Dream.PutDown.self, callback: callback)
        default: print("Segue has not identifier")
        }
    }
    
    
    deinit {
//        print("DetailSceneRouterImpl - is Deinit!")
    }
    
}

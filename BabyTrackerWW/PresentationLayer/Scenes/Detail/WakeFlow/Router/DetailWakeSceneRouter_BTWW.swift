//
//  DetailWakeSceneRouter_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


protocol DetailWakeSceneRouterProtocol_BTWW {
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ())
}

//MARK: - Implementation -

final class DetailWakeSceneRouter_BTWW: DetailWakeSceneRouterProtocol_BTWW {
    
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ()) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        guard let vc = segue.destination as? PickerSceneViewController_BTWW else { return }
        
        switch segue {
        case _ where segue.identifier == String.init(describing: Wake.WakeUp.self): vc.configurator.configureScene(view: vc, type: Wake.WakeUp.self, callback: callback)
        case _ where segue.identifier == String.init(describing: Wake.WakeWindow.self):
            vc.configurator.configureScene(view: vc, type: Wake.WakeWindow.self, callback: callback)
        case _ where segue.identifier == String.init(describing: Wake.Signs.self): vc.configurator.configureScene(view: vc, type: Wake.Signs.self, callback: callback)
        default:
            print("Segue have not identifier")
        }
    }
    
    
    deinit {
//        print("DetailSceneRouterImpl - is Deinit!")
    }
    
}

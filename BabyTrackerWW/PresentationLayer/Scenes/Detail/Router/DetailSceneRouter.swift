//
//  DetailSceneRouter.swift
//  Baby tracker
//
//  Created by Max on 14.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


protocol DetailSceneRouterProtocol {
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ())
}

//MARK: - Implementation -

final class DetailSceneRouterImpl: DetailSceneRouterProtocol {
    
    func prepare<S>(for segue: S, callback: @escaping (LifeCycleProperty) -> ()) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        guard let vc = segue.destination as? PickerViewController else { return }
        
        
        if segue.source is DreamDetailSceneViewController {
             switch segue {
             case _ where segue.identifier == "FallAsleep": vc.configurator.configureScene(view: vc, type: Dream.FallAsleep.self, callback: callback)
                case _ where segue.identifier == "PutDown": vc.configurator.configureScene(view: vc, type: Dream.PutDown.self, callback: callback)
//                case _ where segue.identifier == "WakeUp": vc.configurator.configureScene(view: vc, type: Dream.WakeUp.self, callback: callback)
                default: print("Segue have not identifier")
                }
        } else if
            segue.source is WakeDetailSceneViewController {
              switch segue {
                    case _ where segue.identifier == "WakeUp": vc.configurator.configureScene(view: vc, type: Wake.WakeUp.self, callback: callback)
                    case _ where segue.identifier == "WakeWindow": vc.configurator.configureScene(view: vc, type: Wake.WakeWindow.self, callback: callback)
                    case _ where segue.identifier == "Signs": vc.configurator.configureScene(view: vc, type: Wake.Signs.self, callback: callback)
                    default: print("Segue have not identifier")
                }
            }
    }
    
    deinit {
            print("DetailSceneRouterImpl - is Deinit!")
    }
    
}

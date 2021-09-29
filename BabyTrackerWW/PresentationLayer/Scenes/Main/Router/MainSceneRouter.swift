//
//  MainSceneRouter.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


// Роутер - логика переходов. Вью - глупые переходы по идентификатору со сториборда
protocol MainSceneRouterProtocol {
    func prepare<S,D>(for segue: S, delegate: D)
    func perform(type: LifeCycle, callback: (String) -> ())
}

//MARK: - Implementation -

final class MainSceneRouterImpl: MainSceneRouterProtocol {

    func prepare<S,D>(for segue: S, delegate: D) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        
        if let vc = segue.destination as? DreamDetailSceneViewController { // DetailDreamSceneViewController
            vc.configurator.configureScene(view: vc, delegate: delegate)
            vc.presenter.startDidSelectFlow() // startDidSelectWakeFlow()
            
        } else
        if let vc = segue.destination as? WakeDetailSceneViewController {
            vc.configurator.configureScene(view: vc, delegate: delegate)
            vc.presenter.startDidSelectFlow() // startDidSelectDreamFlow()
            
        } else
        if let vc = segue.destination as? SelectSceneTableViewController {
            vc.configurator.configureScene(view: vc, delegate: delegate)
            
        } else
        if let vc = segue.destination as? CalendarSceneViewController {
            vc.configurator.configureScene(view: vc, delegate: delegate)
            }
    }
    //    deinit {
    //        print("MainSceneRouterImpl - is Deinit!")
    //    }
    
    func perform(type: LifeCycle, callback: (String) -> ()) {
        switch type {
        case _ where type is Wake: callback("didSelectWakeAction")
        case _ where type is Dream: callback("didSelectDreamAction")
            
        default:
            print("Error! didSelectAction can not be performed")
        }
    }
}



//   case _ where segue.identifier == "addNewDreamButton": print("Default flow implementation on Detail Scene")


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

    private var selectIndex: Int?
    
    func prepare<S,D>(for segue: S, delegate: D) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        
        if let vc = segue.destination as? DreamDetailSceneViewController, let index = selectIndex {
            vc.configurator.configureScene(view: vc, delegate: delegate)
            vc.presenter.didSelectFlow(at: index)
            
        } else
        if let vc = segue.destination as? WakeDetailSceneViewController, let index = selectIndex {
            vc.configurator.configureScene(view: vc, delegate: delegate)
            vc.presenter.didSelectFlow(at: index)
            
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
        selectIndex = type.index
        switch type {
        case _ where type is Dream: callback("didSelect" + String.init(describing: Dream.self))
        case _ where type is Wake: callback ("didSelect" + String.init(describing: Wake.self))
        default:
            print("Error! Input type \(type) cannot be recognized")
        }
    }
}

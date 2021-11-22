//
//  MainSceneRouter.swift
//  Baby tracker
//
//  Created by Max on 13.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


protocol MainSceneRouterProtocol {
    func prepare<S,D,V>(for segue: S, delegate: D, parentVC: V?)
    func perform<V>(type: LifeCycle, vc: V)
}

//MARK: - Implementation -

final class MainSceneRouterImpl: MainSceneRouterProtocol {
    
    private var selectIndex: Int?
    
    func prepare<S,D,V>(for segue: S, delegate: D, parentVC: V?) {
        guard let segue = segue as? UIStoryboardSegue else { return }
        
        if let detailDreamVC = segue.destination as? DetailDreamSceneViewController {
            detailDreamVC.configurator.configureScene(view: detailDreamVC, delegate: delegate)
            guard selectIndex != nil else { detailDreamVC.presenter.addNewFlow(); return }
            detailDreamVC.presenter.didSelectFlow(at: selectIndex!)
            selectIndex = nil

        } else
            if let detailWakeVC = segue.destination as? DetailWakeSceneViewController {
                detailWakeVC.configurator.configureScene(view: detailWakeVC, delegate: delegate)
                guard selectIndex != nil else { detailWakeVC.presenter.addNewFlow(); return }
                detailWakeVC.presenter.didSelectFlow(at: selectIndex!)
                selectIndex = nil
                
            } else
                if let selectVC = segue.destination as? SelectSceneTableViewController,
                    let parentVC = parentVC as? MainSceneTableViewController {
//                    selectVC.configurator.configureScene(view: selectVC, delegate: delegate)
                    selectVC.popoverPresentationController?.delegate = parentVC
                    selectVC.segueCallback = { identifire in
                        switch identifire {
                        case 0: parentVC.performSegue(withIdentifier: "addNew" + String.init(describing: Dream.self), sender: nil)
                        case 1: parentVC.performSegue(withIdentifier: "addNew" + String.init(describing: Wake.self), sender: nil)
                        default: print("Error! Input identifire \(identifire) cannot be recognized")
                        }
                    }
                    
                } else
                    if let calendarVC = segue.destination as? CalendarSceneViewController {
                        calendarVC.configurator.configureScene(view: calendarVC, delegate: delegate)
        }
    }
    
    
    func perform<V>(type: LifeCycle, vc: V) {
        guard let vc = vc as? MainSceneTableViewController else { return }
        selectIndex = type.index
        switch type {
        case _ where type is Dream: vc.performSegue(withIdentifier: "didSelect" + String.init(describing: Dream.self), sender: nil)
        //            callback("didSelect" + String.init(describing: Dream.self))
        case _ where type is Wake: vc.performSegue(withIdentifier: "didSelect" + String.init(describing: Wake.self), sender: nil)
        //            callback ("didSelect" + String.init(describing: Wake.self))
        default:
            print("Error! Input type \(type) cannot be recognized")
        }
    }
    
    //    deinit {
    //        print("MainSceneRouterImpl - is Deinit!")
    //    }
}

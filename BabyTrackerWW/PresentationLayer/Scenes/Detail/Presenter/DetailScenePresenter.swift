//
//  DetailScenePresenter.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//
import Foundation

protocol DetailScenePresenterProtocol: AnyObject {
    
    func prepare<S>(for segue: S)
    func saveButtonTapped()
    func startDidSelectFlow()
    func startAddNewFlow(with type: LifeCycle.Type)
    
    func viewDidLoad()
    
    var setLabelCallback: (([String]) -> ())! { get set } // в дальнейшем реализовать обратный вызов в виде универсального обзервера
}


//MARK: - Implementation -

final class DetailScenePresenterImpl: DetailScenePresenterProtocol {
   
    private let router: DetailSceneRouterProtocol
    private weak var delegate: DetailSceneDelegate!
    
    init (delegate: DetailSceneDelegate, router: DetailSceneRouterProtocol) {
        self.delegate = delegate
        self.router = router
    }
    
    private var dream: Dream?
    private var wake: Wake?
    
    //MARK: - View (View Input)
    
    var setLabelCallback: (([String]) -> ())! // Не нравится тут опционал :(
    
    func viewDidLoad() {
        switch self.viewDidLoad {
        case _ where dream != nil : setLabelCallback([dream!.fallAsleep,
                                                      dream!.putDown])
        case _ where wake != nil: setLabelCallback([wake!.wakeUp.rawValue,
                                                    wake!.wakeWindow.rawValue,
                                                    wake!.signs.rawValue])
        default: print("Error! DetailScenePresenterImpl.viewDidLoad()")
        }
    }

    //MARK: - Presenter (View Output)
    
    // -----
    func startDidSelectFlow() {
        let lifeCycle = delegate.showLifeCycle()
        switch lifeCycle {
        case let lifeCycle as Dream: self.dream = lifeCycle
        case let lifeCycle as Wake: self.wake = lifeCycle
        default: print("Error! DetailScenePresenterImpl.startDidSelectFlow()")
        }
    }
        

    func startAddNewFlow(with type: LifeCycle.Type) {
         switch type {
         case _ where type is Dream.Type: dream = Dream(index: delegate.getAvailableIndex(), putDown: .brestFeeding, fallAsleep: .crying)
         case _ where type is Wake.Type: wake = Wake(index: delegate.getAvailableIndex(), wakeUp: .calm, wakeWindow: .calm, signs: .crying)
                  default: print("Error! DetailScenePresenterImpl.addNewFlow()") // Потом исправить описание ошибки!
              }
    }
    
    func saveButtonTapped() {
             switch self.saveButtonTapped {
                // как захватить не ниловое значение? или не нуадо это вообще?
             case _ where dream != nil: delegate.changeLifeCycle(new: dream!)
             case _ where wake != nil: delegate.changeLifeCycle(new: wake!)
             default: print("Error! DetailScenePresenterImpl.saveButtonTapped()") // Потом исправить описание ошибки!
             }
         }

    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            if self.dream != nil {
                 switch result {
                    //Протестить!!!!! 28.10.2021
                 case let result as Dream.FallAsleep: self.dream!.fallAsleep = result.rawValue
                 case let result as Dream.PutDown: self.dream!.putDown = result.rawValue
//                    case _ where result is Dream.WakeUp: self.dream!.wakeUp = result as! Dream.WakeUp
                    default: print("Error! Result is not be identify")
                }
                //Update view labels
                self.setLabelCallback([self.dream!.fallAsleep,
                                       self.dream!.putDown])
            } else if
                self.wake != nil {
                  switch result {
                    case _ where result is Wake.WakeUp: self.wake!.wakeUp = result as! Wake.WakeUp
                    case _ where result is Wake.WakeWindow: self.wake!.wakeWindow = result as! Wake.WakeWindow
                    case _ where result is Wake.Signs: self.wake!.signs = result as! Wake.Signs
                    default: print("Error! Result is not be identify")
                }
                //Update view labels
                self.setLabelCallback([self.wake!.wakeUp.rawValue,
                                       self.wake!.wakeWindow.rawValue,
                                       self.wake!.signs.rawValue])
            }
        }
    }
    
    
    deinit {
        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}


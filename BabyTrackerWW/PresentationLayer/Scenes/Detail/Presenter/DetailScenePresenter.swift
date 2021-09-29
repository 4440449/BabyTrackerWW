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
    func startAddNewFlow()
    
    func viewDidLoad()
    
    var setLabelCallback: (((String), (String), (String)) -> ())! { get set } // в дальнейшем реализовать обратный вызов в виде универсального обзервера
}


//MARK: - Implementation -

final class DetailScenePresenterImpl: DetailScenePresenterProtocol {
            
    private let router: DetailSceneRouterProtocol
    
    weak var dreamDelegate: DreamDetailSceneDelegate?
    weak var wakeDelegate: WakeDetailSceneDelegate?
    
    init (router: DetailSceneRouterProtocol) {
        self.router = router
    }
    
    
    private var dream = Dream(index: 0, putDown: .brestFeeding, fallAsleep: .crying, wakeUp: .happy)
    private var wake = Wake(index: 0, wakeUp: .calm, wakeWindow: .fussy, signs: .freeze) { didSet { print(self.wake.index)} }
 
    
    //MARK: - View (View Input)
    
    var setLabelCallback: (((String), (String), (String)) -> ())! // Не нравится тут опционал :(
    
    func viewDidLoad() {
        switch self.viewDidLoad {
        case _ where self.dreamDelegate != nil: setLabelCallback((dream.putDown.rawValue),
                                                                 (dream.fallAsleep.rawValue),
                                                                 (dream.wakeUp.rawValue))
        case _ where self.wakeDelegate != nil: setLabelCallback((wake.wakeUp.rawValue),
                                                                (wake.wakeWindow.rawValue),
                                                                (wake.signs.rawValue))
        default: print("Error! DetailScenePresenterImpl.viewDidLoad()")
        }
    }

    //MARK: - Presenter (View Output)
    
    
    func startDidSelectFlow() {
        switch self.startDidSelectFlow {
            // Просто показываю выбранный Лайфцайкл!
        case _ where dreamDelegate != nil: dream = dreamDelegate!.showDream()
        case _ where wakeDelegate != nil: wake = wakeDelegate!.showWake()
        default: print("Error! DetailScenePresenterImpl.startDidSelectFlow()") // Потом исправить описание ошибки!
        }
    }
    
    
    func startAddNewFlow() {
        switch self.startAddNewFlow {
        case _ where dreamDelegate != nil: dream = Dream(index: dreamDelegate!.getAvailableIndexForDream(), putDown: .brestFeeding, fallAsleep: .crying, wakeUp: .happy)
        case _ where wakeDelegate != nil: // получить индекс
            wake = Wake(index: wakeDelegate!.getAvailableIndexForWake(), wakeUp: .calm, wakeWindow: .fussy, signs: .freeze)
        default: print("Error! DetailScenePresenterImpl.addNewFlow()") // Потом исправить описание ошибки!
        }
    }


    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            if self.dreamDelegate != nil {
                 switch result {
                    case _ where result is Dream.PutDown: self.dream.putDown = result as! Dream.PutDown
                    case _ where result is Dream.FallAsleep: self.dream.fallAsleep = result as! Dream.FallAsleep
                    case _ where result is Dream.WakeUp: self.dream.wakeUp = result as! Dream.WakeUp
                    default: print("Error! Result is not be identify")
                }
                //Update view labels
                self.setLabelCallback((self.dream.putDown.rawValue),
                                      (self.dream.fallAsleep.rawValue),
                                      (self.dream.wakeUp.rawValue))
            } else if
                self.wakeDelegate != nil {
                  switch result {
                    case _ where result is Wake.WakeUp: self.wake.wakeUp = result as! Wake.WakeUp
                    case _ where result is Wake.WakeWindow: self.wake.wakeWindow = result as! Wake.WakeWindow
                    case _ where result is Wake.Signs: self.wake.signs = result as! Wake.Signs
                    default: print("Error! Result is not be identify")
                }
                //Update view labels
                self.setLabelCallback((self.wake.wakeUp.rawValue),
                                      (self.wake.wakeWindow.rawValue),
                                      (self.wake.signs.rawValue))
            }
        }
    }
    
    func saveButtonTapped() {
        switch self.saveButtonTapped {
        case _ where dreamDelegate != nil: dreamDelegate!.changeDream(new: dream)
        case _ where wakeDelegate != nil: wakeDelegate!.changeWake(new: wake)
        default: print("Error! DetailScenePresenterImpl.saveButtonTapped()") // Потом исправить описание ошибки!
        }
    }
    
    deinit {
        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}


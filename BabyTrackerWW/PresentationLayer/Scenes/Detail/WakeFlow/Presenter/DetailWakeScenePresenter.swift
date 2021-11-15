//
//  DetailWakeScenePresenter.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailWakeScenePresenterProtocol: AnyObject {
    
//    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ())
    var wake: Publisher<Wake> { get }
    func didSelectFlow(at index: Int)
    func addNewFlow()
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


//MARK: - Implementation -

final class DetailWakeScenePresenterImpl: DetailWakeScenePresenterProtocol {
    
    
    // MARK: - Dependencies
    
    private let delegate: DetailWakeSceneDelegate
    private let router: DetailWakeSceneRouterProtocol
    
    init (delegate: DetailWakeSceneDelegate, router: DetailWakeSceneRouterProtocol) {
        self.delegate = delegate
        self.router = router
    }
    
    // MARK: - State
    
    private var selectIndex: Int?
    var wake = Publisher(value: Wake(index: 0, wakeUp: .crying, wakeWindow: .calm, signs: .crying))
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.labelStateNotifierStorage.forEach {
//                    $0.callback([self.wake.wakeUp.rawValue,
//                                 self.wake.wakeWindow.rawValue,
//                                 self.wake.signs.rawValue])
//                }
//            }
//        }
//    }
    
    // MARK: - View Input (Observing)
    
    // Отписку не буду делать, т.к. и так все задеинитится
//    private var labelStateNotifierStorage = [Observer<[String]>]()
//
//    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ()) {
//        labelStateNotifierStorage.append(Observer(observer, callback))
//    }
    
    //MARK: - View Output
    
    func addNewFlow() {
        wake.value = Wake(index: delegate.shareStateForDetailWakeScene().lifeCycle.endIndex,
                    wakeUp: .crying,
                    wakeWindow: .calm,
                    signs: .crying)
    }
    
    func didSelectFlow(at index: Int) {
        selectIndex = index
        wake.value = delegate.shareStateForDetailWakeScene().lifeCycle[index] as! Wake
    }
    
    func saveButtonTapped() {
        selectIndex == nil ?
            delegate.add(new: wake.value)
            :
            delegate.change(wake.value)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Wake.WakeUp: self.wake.value.wakeUp = result
            case let result as Wake.WakeWindow: self.wake.value.wakeWindow = result
            case let result as Wake.Signs: self.wake.value.signs = result
            default: print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}


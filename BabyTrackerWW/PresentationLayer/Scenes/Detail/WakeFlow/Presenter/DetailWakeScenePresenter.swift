//
//  DetailWakeScenePresenter.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailWakeScenePresenterProtocol: AnyObject {
    
    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ())
    func didSelectFlow(at index: Int)
    func addNewFlow()
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


//MARK: - Implementation -

final class DetailWakeScenePresenterImpl: DetailWakeScenePresenterProtocol {
    
    
    // MARK: - Dependencies
    
    private let delegate: DetailSceneDelegate
    private let router: DetailWakeSceneRouterProtocol
    
    init (delegate: DetailSceneDelegate, router: DetailWakeSceneRouterProtocol) {
        self.delegate = delegate
        self.router = router
    }
    
    // MARK: - State
    
    private var selectIndex: Int?
    private var wake: Wake! {
        didSet {
            DispatchQueue.main.async {
                self.labelStateNotifierStorage.forEach {
                    $0.callback([self.wake.wakeUp.rawValue,
                                 self.wake.wakeWindow.rawValue,
                                 self.wake.signs.rawValue])
                }
            }
        }
    }
    
    // MARK: - View Input (Observing)
    
    // Отписку не буду делать, т.к. и так все задеинитится
    private var labelStateNotifierStorage = [Observer<[String]>]()
    
    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ()) {
        labelStateNotifierStorage.append(Observer(observer, callback))
    }
    
    //MARK: - View Output
    
    func addNewFlow() {
        wake = Wake(index: delegate.shareStateForDetailScene().lifeCycle.endIndex,
                    wakeUp: .calm,
                    wakeWindow: .calm,
                    signs: .crying)
    }
    
    func didSelectFlow(at index: Int) {
        selectIndex = index
        wake = delegate.shareStateForDetailScene().lifeCycle[index] as? Wake
    }
    
    func saveButtonTapped() {
        selectIndex == nil ?
            delegate.add(new: wake)
            :
            delegate.change(current: wake)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Wake.WakeUp: self.wake.wakeUp = result
            case let result as Wake.WakeWindow: self.wake.wakeWindow = result
            case let result as Wake.Signs: self.wake.signs = result
            default: print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}

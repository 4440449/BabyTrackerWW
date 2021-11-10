//
//  DetailDreamScenePresenter.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailDreamScenePresenterProtocol: AnyObject {
    
    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ())
    func didSelectFlow(at index: Int)
    func addNewFlow()
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


//MARK: - Implementation -

final class DetailDreamScenePresenterImpl: DetailDreamScenePresenterProtocol {
    
    
    // MARK: - Dependencies
    
    private let delegate: DetailSceneDelegate
    private let router: DetailDreamSceneRouterProtocol
    
    init (delegate: DetailSceneDelegate, router: DetailDreamSceneRouterProtocol) {
        self.delegate = delegate
        self.router = router
    }
    
    // MARK: - State
    
    private var selectIndex: Int?
    private var dream: Dream! {
        didSet {
            DispatchQueue.main.async {
                self.labelStateNotifierStorage.forEach {
                    $0.callback([self.dream.fallAsleep,
                                 self.dream.putDown])
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
        dream = Dream(index: delegate.shareStateForDetailScene().lifeCycle.endIndex,
                      putDown: .brestFeeding,
                      fallAsleep: .crying)
    }
    
    func didSelectFlow(at index: Int) {
        selectIndex = index
        dream = delegate.shareStateForDetailScene().lifeCycle[index] as? Dream
    }
    
    func saveButtonTapped() {
        selectIndex == nil ?
        delegate.add(new: dream)
        :
        delegate.change(current: dream)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Dream.FallAsleep: self.dream.fallAsleep = result.rawValue
            case let result as Dream.PutDown: self.dream.putDown = result.rawValue
            default: print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
//        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}


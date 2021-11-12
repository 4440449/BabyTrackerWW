//
//  DetailDreamScenePresenter.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailDreamScenePresenterProtocol: AnyObject {
    
//    func subscribeToLabelState(_ observer: AnyObject, _ callback: @escaping ([String]) -> ())
    var dream: Publisher<Dream> { get }
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
    var dream = Publisher(value: Dream(index: 0, fallAsleep: .crying, putDown: .brestFeeding))

    
    //MARK: - View Output
    
    func addNewFlow() {
        dream.value = Dream(index: delegate.shareStateForDetailScene().lifeCycle.endIndex,
                            fallAsleep: .crying,
                            putDown: .brestFeeding)
    }
    
    func didSelectFlow(at index: Int) {
        selectIndex = index
        dream.value = delegate.shareStateForDetailScene().lifeCycle[index] as! Dream
    }
    
    func saveButtonTapped() {
        selectIndex == nil ?
            delegate.add(new: dream.value)
        :
            delegate.change(current: dream.value)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Dream.FallAsleep: self.dream.value.fallAsleep = result.rawValue
            case let result as Dream.PutDown: self.dream.value.putDown = result.rawValue
            default: print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
        print("DetailScenePresenterImpl - is Deinit!")
    }
    
}


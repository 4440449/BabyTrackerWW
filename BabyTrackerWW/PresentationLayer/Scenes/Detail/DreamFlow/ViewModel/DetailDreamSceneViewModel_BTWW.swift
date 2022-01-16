//
//  DetailDreamSceneViewModel_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import MommysEye


protocol DetailDreamSceneViewModelProtocol_BTWW: AnyObject {
    
    var dream: Publisher<Dream> { get }
    var selectIndex: Int? { get set }
    func viewDidLoad()
    func textViewDidChange(text: String)
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


//MARK: - Implementation -

final class DetailDreamSceneViewModel_BTWW: DetailDreamSceneViewModelProtocol_BTWW {
    
    
    // MARK: - Dependencies
    
    private let delegate: DetailDreamSceneDelegate_BTWW
    private let router: DetailDreamSceneRouterProtocol_BTWW
    
    init (delegate: DetailDreamSceneDelegate_BTWW, router: DetailDreamSceneRouterProtocol_BTWW) {
        self.delegate = delegate
        self.router = router
    }
    
    
    // MARK: - State
    
    var selectIndex: Int?
    var dream = Publisher(value: Dream(index: 0, fallAsleep: .crying, putDown: .brestFeeding))

    
    //MARK: - View Output
    
    private func addNewFlow() {
        dream.value = Dream(index: delegate.shareStateForDetailDreamScene().lifeCycle.endIndex,
                            fallAsleep: .crying,
                            putDown: .brestFeeding)
    }
    
    private func didSelectFlow(at index: Int) {
        selectIndex = index
        dream.value = delegate.shareStateForDetailDreamScene().lifeCycle[index] as! Dream
    }
    
    
        //MARK: - View Output
    
    func viewDidLoad() {
        selectIndex == nil ? addNewFlow() : didSelectFlow(at: selectIndex!)
    }
    
    func textViewDidChange(text: String) {
        dream.value.note = text
    }
    
    func saveButtonTapped() {
        selectIndex == nil ? delegate.add(new: dream.value) : delegate.change(dream.value)
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
        print("DetailDreamSceneViewModel_BTWW - is Deinit!")
    }
    
}


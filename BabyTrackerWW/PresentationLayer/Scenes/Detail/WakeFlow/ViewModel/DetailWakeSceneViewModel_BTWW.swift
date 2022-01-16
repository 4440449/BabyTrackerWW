//
//  DetailWakeSceneViewModel_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation
import MommysEye


protocol DetailWakeSceneViewModelProtocol_BTWW: AnyObject {
    
    var wake: Publisher<Wake> { get }
    var selectIndex: Int? { get set }
    func viewDidLoad()
    func textViewDidChange(text: String)
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


//MARK: - Implementation -

final class DetailWakeSceneViewModel_BTWW: DetailWakeSceneViewModelProtocol_BTWW {
    
    
    // MARK: - Dependencies
    
    private let delegate: DetailWakeSceneDelegate_BTWW
    private let router: DetailWakeSceneRouterProtocol_BTWW
    
    init (delegate: DetailWakeSceneDelegate_BTWW, router: DetailWakeSceneRouterProtocol_BTWW) {
        self.delegate = delegate
        self.router = router
    }
    
    // MARK: - State
    
    var selectIndex: Int?
    var wake = Publisher(value: Wake(index: 0, wakeUp: .crying, wakeWindow: .calm, signs: .crying))
    
    
    //MARK: - Internal setup
    
    private func addNewFlow() {
        wake.value = Wake(index: delegate.shareStateForDetailWakeScene().lifeCycle.endIndex,
                          wakeUp: .crying,
                          wakeWindow: .calm,
                          signs: .crying)
    }
    
    private func didSelectFlow(at index: Int) {
        selectIndex = index
        wake.value = delegate.shareStateForDetailWakeScene().lifeCycle[index] as! Wake
    }
    
    
    //MARK: - View Output
    
    func viewDidLoad() {
        selectIndex == nil ? addNewFlow() : didSelectFlow(at: selectIndex!)
    }
    
    func textViewDidChange(text: String) {
        wake.value.note = text
    }
    
    func saveButtonTapped() {
        selectIndex == nil ? delegate.add(new: wake.value) : delegate.change(wake.value)
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
        print("DetailWakeSceneViewModel_BTWW - is Deinit!")
    }
    
}


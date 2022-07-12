//
//  DetailWakeScenePresenter_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailWakeScenePresenterInputProtocol_BTWW {
    func viewDidLoad()
    func getWakeUpOutletButtonText() -> String
    func getWakeWindowOutletButtonText() -> String
    func getSignsOutletButtonText() -> String
    func getTexForTextView() -> String
    func getCounterForTextViewLabel() -> Int
    func textViewDidChange(text: String)
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}

protocol DetailWakeScenePresenterOutputProtocol_BTWW: AnyObject {
    func reloadData()
}


//MARK: - Implementation -

final class DetailWakeScenePresenter_BTWW: DetailWakeScenePresenterInputProtocol_BTWW {
    
    // MARK: - Dependencies
    
    private unowned var view: DetailWakeScenePresenterOutputProtocol_BTWW
    private let interactor: DetailWakeSceneInteractor_BTWW
    private let router: DetailWakeSceneRouterProtocol_BTWW
    
    init (view: DetailWakeScenePresenterOutputProtocol_BTWW,
          interactor: DetailWakeSceneInteractor_BTWW,
          router: DetailWakeSceneRouterProtocol_BTWW,
          selectedIndex: Int?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.selectedIndex = selectedIndex
    }
    
    // MARK: - State
    
    private var selectedIndex: Int?
    
    
    // MARK: - Buffer
    
    private var wake: Wake! {
        didSet {
            view.reloadData()
        }
    }
    
    
    //MARK: - Internal setup
    
    private func addNewFlow() {
        wake = Wake(index: interactor.shareStateForDetailWakeScene().lifeCycle.endIndex,
                    wakeUp: .crying,
                    wakeWindow: .calm,
                    signs: .crying)
    }
    
    private func didSelectFlow(at index: Int) {
        selectedIndex = index
        wake = interactor.shareStateForDetailWakeScene().lifeCycle[index] as? Wake
    }
    
    
    //MARK: - View Output
    
    func viewDidLoad() {
        selectedIndex == nil ? addNewFlow() : didSelectFlow(at: selectedIndex!)
    }
    
    func getWakeUpOutletButtonText() -> String {
        return wake.wakeUp.rawValue
    }
    
    func getWakeWindowOutletButtonText() -> String {
        return wake.wakeWindow.rawValue
    }
    
    func getSignsOutletButtonText() -> String {
        return wake.signs.rawValue
    }
    
    func getTexForTextView() -> String {
        return wake.note
    }
    
    func getCounterForTextViewLabel() -> Int {
        return wake.note.count
    }
    
    func textViewDidChange(text: String) {
        wake.note = text
    }
    
    func saveButtonTapped() {
        selectedIndex == nil ? interactor.add(new: wake) : interactor.change(wake)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Wake.WakeUp:
                self.wake.wakeUp = result
            case let result as Wake.WakeWindow:
                self.wake.wakeWindow = result
            case let result as Wake.Signs:
                self.wake.signs = result
            default:
                print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
//        print("DetailWakeScenePresenter_BTWW - is Deinit!")
    }
    
}


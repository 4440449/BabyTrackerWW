//
//  DetailDreamScenePresenter_BTWW.swift
//  BabyTrackerWW
//
//  Created by Max on 08.11.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import Foundation


protocol DetailDreamScenePresenterInputProtocol_BTWW {
    func viewDidLoad()
    func getFallAsleepOutletButtonLabel() -> String
    func getPutDownOutletButtonLabel() -> String
    func getTexForTextView() -> String
    func getCounterForTextViewLabel() -> Int
    func textViewDidChange(text: String)
    func saveButtonTapped()
    func prepare<S>(for segue: S)
}


protocol DetailDreamScenePresenterOutputProtocol_BTWW: AnyObject {
    func reloadData()
}

//MARK: - Implementation -

final class DetailDreamScenePresenter_BTWW: DetailDreamScenePresenterInputProtocol_BTWW {

    // MARK: - Dependencies
    
    private unowned var view: DetailDreamScenePresenterOutputProtocol_BTWW
    private let interactor: DetailDreamSceneInteractor_BTWW
    private let router: DetailDreamSceneRouterProtocol_BTWW
    
    init(view: DetailDreamScenePresenterOutputProtocol_BTWW,
         interactor: DetailDreamSceneInteractor_BTWW,
         router: DetailDreamSceneRouterProtocol_BTWW,
         selectedIndex: Int?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.selectedIndex = selectedIndex
    }
    
    
    // MARK: - State
    
    private var selectedIndex: Int?
    
    
    // MARK: - Buffer
    
    private var dream: Dream! {
        didSet {
            view.reloadData()
        }
    }
    
    
    //MARK: - Internal setup
    
    private func addNewFlow() {
        dream = Dream(index: interactor.shareStateForDetailDreamScene().lifeCycle.endIndex,
                      fallAsleep: .crying,
                      putDown: .brestFeeding)
    }
    
    private func didSelectFlow(at index: Int) {
        selectedIndex = index
        dream = interactor.shareStateForDetailDreamScene().lifeCycle[index] as? Dream
    }
    
    
    //MARK: - View Output
    
    func viewDidLoad() {
        selectedIndex == nil ? addNewFlow() : didSelectFlow(at: selectedIndex!)
    }
    
    func getFallAsleepOutletButtonLabel() -> String {
        return dream.fallAsleep
    }
    
    func getPutDownOutletButtonLabel() -> String {
        return dream.putDown
    }
    
    func getTexForTextView() -> String {
        return dream.note
    }
    
    func getCounterForTextViewLabel() -> Int {
        return dream.note.count
    }
    
    func textViewDidChange(text: String) {
        dream?.note = text
    }
    
    func saveButtonTapped() {
        selectedIndex == nil ? interactor.add(new: dream) : interactor.change(dream)
    }
    
    func prepare<S>(for segue: S) {
        router.prepare(for: segue) { [unowned self] result in
            switch result {
            case let result as Dream.FallAsleep:
                self.dream.fallAsleep = result.rawValue
            case let result as Dream.PutDown:
                self.dream.putDown = result.rawValue
            default:
                print("Error! Result type \(result) is not be recognized")
            }
        }
    }
    
    
    deinit {
//        print("DetailDreamScenePresenter_BTWW - is Deinit!")
    }
    
}


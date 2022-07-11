//
//  PickerSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class PickerSceneConfigurator_BTWW {
    
    func configureScene<T: CaseIterable & RawRepresentable & LifeCycleProperty>(view: PickerSceneViewController_BTWW, type: T.Type, callback: @escaping (T) -> ()) {
        let presenter = PickerScenePresenter_BTWW(lifeCyclePropertyType: type, callback: callback)
        view.setupPresenter(presenter)
    }
    
    deinit {
//        print("PickerConfigurator - is Deinit!")
    }
}

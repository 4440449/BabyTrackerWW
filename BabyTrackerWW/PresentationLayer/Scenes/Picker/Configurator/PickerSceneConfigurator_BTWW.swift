//
//  PickerSceneConfigurator_BTWW.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class PickerSceneConfigurator_BTWW {
    
    func configureScene<T: CaseIterable & RawRepresentable & LifeCycleProperty>(view: PickerViewController_BTWW, type: T.Type, callback: @escaping (T) -> ()) {
        let viewModel = PickerSceneViewModel_BTWW(lifeCyclePropertyType: type, callback: callback)
        view.viewModel = viewModel
    }
    
    deinit {
//        print("PickerConfigurator - is Deinit!")
    }
}

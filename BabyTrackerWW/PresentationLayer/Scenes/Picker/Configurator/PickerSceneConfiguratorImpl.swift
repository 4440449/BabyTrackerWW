//
//  PickerSceneConfigurator.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//


final class PickerSceneConfiguratorImpl {
    
    func configureScene<T: CaseIterable & RawRepresentable & LifeCycleProperty>(view: PickerViewController, type: T.Type, callback: @escaping (T) -> ()) {
        let presenter = PickerScenePresenterImpl(lifeCyclePropertyType: type, callback: callback)
        view.presenter = presenter
    }
    
    deinit {
//        print("PickerConfigurator - is Deinit!")
    }
}

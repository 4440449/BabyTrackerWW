//
//  SceneDelegate.swift
//  Baby tracker
//
//  Created by Max on 09.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit
import MommysEye


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let sceneState = Publisher(value: SceneState.background)


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
//        print("sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
//        print("sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
//        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
//        print("sceneWillEnterForeground")
        sceneState.value = .foreground
        // Развернул полностью
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        print("sceneDidEnterBackground")
        sceneState.value = .background
        // Свернул
        CoreDataStack_BTWW.shared.saveContext()
    }


}


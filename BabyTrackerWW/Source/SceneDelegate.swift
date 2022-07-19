//
//  SceneDelegate.swift
//  Baby tracker
//
//  Created by Max on 09.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit
//import MommysEye


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window?.backgroundColor = .systemBackground
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Развернул полностью
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Свернул
        CoreDataStack_BTWW.shared.saveContext()
    }
    
}


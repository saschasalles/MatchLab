//
//  SceneDelegate.swift
//  MatchLab
//
//  Created by Sascha Sallès on 09/11/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // swiftlint: disable unused_optional_binding
            guard let _ = (scene as? UIWindowScene) else { return }
            print(#function, self)
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function, self)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function, self)
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}

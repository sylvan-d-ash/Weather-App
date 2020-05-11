//
//  SceneDelegate.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let controller = LocationsViewController()
        let navController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        let weather = Webservice()
        weather.getWeatherToday { (_) in
            //
        }
    }

}

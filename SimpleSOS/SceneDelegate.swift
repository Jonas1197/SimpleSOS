//
//  SceneDelegate.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var coordinator: MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
      
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        coordinator = MainCoordinator(navigationController: navController)
        coordinator?.start()
        
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        maybeOpenedFromWidget(urlContexts: connectionOptions.urlContexts)
    }
    
    // App opened from background
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        maybeOpenedFromWidget(urlContexts: URLContexts)
    }

    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>) {
        guard urlContexts.first?.url.scheme == "widget-deeplink" else { return }
        guard let contact = UserDefaults.getContact() else { return }
        call(contact: contact)
    }
    
    func call(contact: SSContact) {
        let phoneNumber = contact.phoneNumber
        guard let url = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:]) { didMakeCall in
            let callData = CallData(fullName: contact.fullName, phoneNumber: phoneNumber, time: Date.DateAndTimeAsString())
            try? Archiver(directory: .callData).put(callData, forKey: phoneNumber)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}


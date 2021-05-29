//
//  MainCoordinator.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit


protocol Coordinator {
    
    var childCoordinator: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    func start()
}


class MainCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SosVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func settings() {
        let vc = SettingsVC.instantiate()
        vc.coordinator = self
        var retrievedContacts = Archiver.retrieveContacts(of: .settingsContact)
        retrievedContacts.append(.init())
        vc.contacts = retrievedContacts
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func history() {
        let vc = HistoryVC.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
}

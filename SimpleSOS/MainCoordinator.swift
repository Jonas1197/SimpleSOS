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
        if let retrievedContacts: [SSContact] = Archiver.retrieveContacts(of: .settingsContact) {
            vc.contacts = retrievedContacts
            vc.contacts.append(.init())
        } else {
            vc.contacts = .init()
            vc.contacts.append(.init())
        }
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func history() {
        let vc = HistoryVC.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func about() {
        let vc = AboutVC.instantiate()
        vc.coordinator = self
        navigationController.dismiss(animated: true, completion: nil)
        navigationController.present(vc, animated: true, completion: nil)
    }
}

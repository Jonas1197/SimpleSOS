//
//  SosVC.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

final class SosVC: UIViewController, Storyboarded {
    
    public static let maxContacts = 6
    
    weak var coordinator:        MainCoordinator?

    private var contact:         SSContact?
    
    private var mainTitle:       MainTitleLabel  = .init()
    
    private var emergencyButton: EmergencyButton = .init()
    
    private var togglesView:     TogglesView     = .init()
    
    var contacts: [SSContact] = Archiver.retrieveContacts()
    
    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    //MARK: - Body
    
    private func setUp() {
        view.backgroundColor = .softRed
        configureMainTitle()
        configureEmergencyButton()
        configureTogglesView()
    }
    
    private func configureMainTitle() {
        mainTitle.add(to: self)
    }
    
    private func configureEmergencyButton() {
        view.addSubview(emergencyButton)
        NSLayoutConstraint.activate([
            emergencyButton.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 15),
            emergencyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emergencyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emergencyButton.heightAnchor.constraint(equalToConstant: view.frame.height/2.2)
        ])
        
        emergencyButton.delegate = self
    }
    
    private func configureTogglesView() {
        togglesView.delegate = self
        view.addSubview(togglesView)
        NSLayoutConstraint.activate([
            togglesView.topAnchor.constraint(equalTo: emergencyButton.bottomAnchor, constant: 50),
            togglesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            togglesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            togglesView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if contacts.isEmpty {
            togglesView.contacts?.append(.init())
        } else {
            togglesView.contacts = contacts
        }
        
        togglesView.configure()
        NotificationCenter.addDefaultObserver(for: self, withNotificationName: Notification.updateToggles, and: #selector(updateToggles))
        
    }
    
    @objc private func updateToggles() {
        contacts = Archiver.retrieveContacts()
        togglesView.contacts = contacts
        togglesView.configure()
    }
    
    private func callNumber(phoneNumber: String) {
        print("calling: \(phoneNumber )")
        guard let url = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


extension SosVC: MainTitleLabelDelegate {
    func shouldPresentEasterEgg() {
        // not working
        print("shouldPresentEasterEgg")
    }
}

extension SosVC: EmergencyButtonDelegate {
    func didRequestEmergencyCall() {
        print("didRequestEmergencyCall")
        if let phoneNumber = contact?.phoneNumber {
            callNumber(phoneNumber: phoneNumber)
        }
    }
    
    func shouldPresentSettings() {
        print("shouldPresentSettings")
        coordinator?.settings()
    }
    
    func shouldPresentEmergencyHistory() {
        coordinator?.history()
    }
}
 
extension SosVC: TogglesViewDelegate {
    func didToggleContact(contact: SSContact) {
        self.contact = contact
    }
}

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

    
    //MARK: - Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
        #warning("add easter egg")
        print("shouldPresentEasterEgg")
    }
}

extension SosVC: EmergencyButtonDelegate {
    func didRequestEmergencyCall() {
        print("didRequestEmergencyCall")
        guard let phoneNumber = contact?.phoneNumber else {
            showAlert(with: "Wait!", "You have to select an emergency contact first.", "Ok")
            return
        }
        
        emergencyButton.prepareForCall()
        callNumber(phoneNumber: phoneNumber)
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
        self.contact = contact.isSelected ? contact : nil
    }
}

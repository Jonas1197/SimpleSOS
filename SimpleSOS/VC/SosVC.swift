//
//  SosVC.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit
import WidgetKit

final class SosVC: UIViewController, Storyboarded {
    
    public static let maxContacts = 6
    
    weak var coordinator:        MainCoordinator?

    private var contact:         SSContact?
    
    private var mainTitle:       MainTitleLabel!
    
    private var emergencyButton: EmergencyButton!
    
    private var togglesView:     TogglesView!

    
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
        addEBCListener()
    }
    
    private func addEBCListener() {
        NotificationCenter.addDefaultObserver(for: self, withNotificationName: Notification.updateEBC, and: #selector(clearEBContact))
    }
    
    private func configureMainTitle() {
        mainTitle          = .init(frame: view.frame)
        mainTitle.delegate = self
        mainTitle.fix(in: view)
    }
    
    private func configureEmergencyButton() {
        emergencyButton          = .init(frame: view.frame)
        emergencyButton.delegate = self
        emergencyButton.fix(in: view, under: mainTitle)
    }
    
    private func configureTogglesView() {
        togglesView          = .init(frame: view.frame)
        togglesView.delegate = self
        togglesView.fix(in: view, under: emergencyButton)

    }
    
    private func call(contact: SSContact) {
        let phoneNumber = contact.phoneNumber
        
        guard let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:]) { didMakeCall in
            let callData = CallData(fullName: contact.fullName, phoneNumber: phoneNumber, time: Date.DateAndTimeAsString())
            
            do {
                try Archiver(directory: .callData).put(callData, forKey: phoneNumber)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func clearEBContact() {
        contact = nil
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
        guard let contact = contact else {
            showAlert(with: "Wait!", "You have to select an emergency contact first.", "Ok")
            return
        }
        
        emergencyButton.prepareForCall()
        call(contact: contact)
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
        
        guard let contact = self.contact else {
            UserDefaults.clear()
            return
        }
        
        UserDefaults.save(contact)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}


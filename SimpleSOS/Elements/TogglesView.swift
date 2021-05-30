//
//  TogglesView.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 11/05/2021.
//

import UIKit

public let maxToggles        = 6
public let maxElementsPerRow = 3
public let maxRows           = 2

protocol TogglesViewDelegate: AnyObject {
    func didToggleContact(contact: SSContact) -> Void
}

class TogglesView: UIView {

    weak var delegate: TogglesViewDelegate? {
        didSet {
            for contact in contacts {
                if contact.isSelected {
                    delegate?.didToggleContact(contact: contact)
                    break
                }
            }
        }
    }
    
    private var contacts: [SSContact] = Archiver.retrieveContacts(of: .selectedContact) {
        didSet {
            configure()
        }
    }
    
    private var mainTitleLabel: UILabel = {
        let label           = UILabel()
        label.text          = "Quick call options"
        label.font          = UIFont(name: Fonts.italic, size: 20)
        label.textAlignment = .center
        label.textColor     = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var toggles:      [(switch: UISwitch, contact: SSContact)] = [(UISwitch, SSContact)]()
    
    private var labels:       [UILabel]     = [UILabel]()
    
    private var vstacks:      [UIStackView] = [UIStackView]()
    
    private var rowOneStacks: [UIStackView] = [UIStackView]()
    
    private var rowTwoStacks: [UIStackView] = [UIStackView]()
    
    private var rowOnehstack: UIStackView   = .init(axis: .horizontal, spacing: 5, alignment: .center, distribution: .fillEqually, tamic: false)
    
    private var rowTowhstack: UIStackView   = .init(axis: .horizontal, spacing: 5, alignment: .center, distribution: .fillEqually, tamic: false)
    
    
    
    //MARK: - Main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func add(toggeWithContact contact: SSContact) {
        let label = UILabel(text: contact.fullName, font: UIFont(name: Fonts.italic, size: 12)!, textColor: .white, tamic: false)
        labels.append(label)
        
        let toggle = UISwitch()
        toggle.onTintColor    = .brightGreen
        toggle.preferredStyle = .sliding
        toggle.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        toggles.append((toggle, contact))
        
        let vstack = UIStackView(views: [label, toggle], axis: .vertical, spacing: 5, alignment: .center, distribution: .fill, tamic: false)
        vstacks.append(vstack)
        
        
        if rowOneStacks.count < maxElementsPerRow{
            rowOneStacks.append(vstack)
            rowOnehstack.addArrangedSubview(vstack)
            
        } else if rowTwoStacks.count < (maxElementsPerRow) {
            rowTwoStacks.append(vstack)
            rowTowhstack.addArrangedSubview(vstack)
        }
        
        contact.isSelected ? (toggle.isOn = true) : (toggle.isOn = false)
        
    }
    
    private func configure() {
        vstacks.removeAll()
        toggles.removeAll()
        labels.removeAll()
        
        rowOnehstack.removeViews()
        rowTowhstack.removeViews()
        
        rowOneStacks.removeAll()
        rowTwoStacks.removeAll()
        
        for contact in contacts where (contact.phoneNumber != SettingsCell.newCellIdentifier) {
            add(toggeWithContact: contact)
        }
    }

    //MARK: - Main
    private func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        NotificationCenter.addDefaultObserver(for: self, withNotificationName: Notification.updateToggles, and: #selector(updateToggles))
        configureMainTitleLabel()
        configureElements()
        configure()
    }
    
    @objc private func updateToggles() {
        contacts = Archiver.retrieveContacts(of: .selectedContact)
    }
    
    private func configureMainTitleLabel() {
        addSubview(mainTitleLabel)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            mainTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func configureElements() {
        addSubview(rowOnehstack)
        NSLayoutConstraint.activate([
            rowOnehstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rowOnehstack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rowOnehstack.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 20)
        ])
        
        addSubview(rowTowhstack)
        NSLayoutConstraint.activate([
            rowTowhstack.topAnchor.constraint(equalTo: rowOnehstack.bottomAnchor, constant: 10),
            rowTowhstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rowTowhstack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func switchToggled(_ sender: UISwitch) {
        for toggle in toggles {
            if toggle.switch != sender && toggle.switch.isOn {
                toggle.switch.setOn(false, animated: true)
                toggle.contact.isSelected = false
                
            } else if toggle.switch == sender {
                toggle.contact.isSelected = sender.isOn
                delegate?.didToggleContact(contact: toggle.contact)
            }
            
            try? Archiver(directory: .selectedContact).put(toggle.contact, forKey: toggle.contact.phoneNumber)
        }
    }
}

//
//  SettingsVC.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit
import ContactsUI

class SettingsVC: UIViewController, Storyboarded {

    public static let maxCells = 7
    
    weak var coordinator: MainCoordinator?
    
    var contacts: [SSContact]!
    
    private let mainTitle = MainTitleLabel()
    
    private var aboutButton: UIButton = {
        let button              = UIButton()
        button.titleLabel?.font = UIFont(name: Fonts.boldItalic, size: 20)
        button.tintColor        = .white
        button.setTitle("About", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tableView: UITableView!
    
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    
    //MARK: - Body
    private func setUp() {
        view.backgroundColor = .softRed
        configureMainTitle()
        configureButton()
        configureTableView()
    }
    
    private func retrieveContacts() {
        contacts = Archiver.retrieveContacts(of: .settingsContact)
        contacts.append(.init())
    }
    
    private func configureMainTitle() {
        mainTitle.fix(in: view)
        mainTitle.text = "Settings"
    }
    
    private func configureButton() {
        view.addSubview(aboutButton)
        NSLayoutConstraint.activate([
            aboutButton.centerYAnchor.constraint(equalTo: mainTitle.centerYAnchor),
            aboutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        aboutButton.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
    }
    
    private func configureTableView() {
        tableView = .init()
        tableView.register(SettingsCell.nib, forCellReuseIdentifier: SettingsCell.reusIdentifier)
        tableView.delegate   = self
        tableView.dataSource = self
        
        fixTableView()
    }
    
    private func fixTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor  = .init(white: 1, alpha: 0.4)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func aboutButtonTapped(_ sender: UIButton) {
        print("aboutButtonTapped")
        coordinator?.about()
    }
}


//MARK: - UITableView
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reusIdentifier) as? SettingsCell else { return UITableViewCell() }
        cell.configure(for: contacts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if contacts[indexPath.row].phoneNumber == SettingsCell.newCellIdentifier {
            onClickPickContact()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return contacts[indexPath.row].phoneNumber == SettingsCell.newCellIdentifier ? false : true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            try? Archiver(directory: .contact).deleteItem(forKey: contacts[indexPath.row].phoneNumber)
            try? Archiver(directory: .selectedContact).deleteItem(forKey: contacts[indexPath.row].phoneNumber)
            
            contacts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            NotificationCenter.post(to: Notification.updateToggles)
        }
    }
}


//MARK:- Contact picker
extension SettingsVC: CNContactPickerDelegate {
    
    func onClickPickContact(){
        if contacts.count >= SettingsVC.maxCells {
            let alert = UIAlertController(title: "Wait!", message: "You can add up to 6 contacts.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
            present(contactPicker, animated: true, completion: nil)
        }
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // user name
        let userName:String = contact.givenName
        
        // user phone number
        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
        
        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
        
        let contact = SSContact(fullName: userName, phoneNumber: firstPhoneNumber.stringValue)
        
        self.contacts.insert(contact, at: 0)
        
        try? Archiver(directory: .contact).put(contact, forKey: contact.phoneNumber)
        
        tableView.reloadData()
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        //
    }
}

//MARK: - SettingsCell
extension SettingsVC: SettingsCellDelegate {
    func settingsCellHasChangedToggleStatus(for contact: SSContact) {
        var index = 0
        for element in contacts {
            if element.phoneNumber == contact.phoneNumber {
                contacts[index] = contact
            } else { index += 1 }
        }
    
        try? Archiver(directory: .contact).put(contact, forKey: contact.phoneNumber)
        
        if contact.isSelected {
            contact.isSelected = false
            try? Archiver(directory: .selectedContact).put(contact, forKey: contact.phoneNumber)
        } else {
            try? Archiver(directory: .selectedContact).deleteItem(forKey: contact.phoneNumber)
        }
        
        NotificationCenter.post(to: Notification.updateToggles)
        NotificationCenter.post(to: Notification.updateEBC)
    }
}

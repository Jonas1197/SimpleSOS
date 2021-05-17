//
//  SSContact.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 12/05/2021.
//

import Foundation

final class SSContact: Codable {
    var fullName: String
    
    var phoneNumber: String
    
    var isSelected: Bool = false
    
    init(fullName: String, phoneNumber: String) {
        self.fullName    = fullName
        self.phoneNumber = phoneNumber
    }
    
    init() {
        try? Archiver(directory: .contact).removeAll()
        
        fullName = ""
        phoneNumber = SettingsCell.newCellIdentifier
        
        try? Archiver(directory: .contact).put(self, forKey: phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(isSelected, forKey: .isSelected)
    }

    required init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName    = try container.decode(String.self, forKey: .fullName)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.isSelected  = try container.decode(Bool.self, forKey: .isSelected)
    }
    
}

//
//  SSContact.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 12/05/2021.
//

import Foundation

final class SSContact: Codable {
    var fullName: String
    
    private var rawPhoneNumber: String
    
    var phoneNumber: String {
        if rawPhoneNumber == SettingsCell.newCellIdentifier {
            return rawPhoneNumber
        } else {
            let spaceless = self.rawPhoneNumber.filter { return $0 != " "}
            let final     = spaceless.filter { return $0 != "‑" }
            return final
        }
    }
    
    var isSelected: Bool = false
    
    init(fullName: String, phoneNumber: String) {
        self.fullName    = fullName
        self.rawPhoneNumber = phoneNumber
    }
    
    init() {
        fullName    = ""
        rawPhoneNumber = SettingsCell.newCellIdentifier
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(rawPhoneNumber, forKey: .phoneNumber)
        try container.encode(isSelected, forKey: .isSelected)
    }

    required init(from decoder: Decoder) throws {
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName       = try container.decode(String.self, forKey: .fullName)
        self.rawPhoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.isSelected     = try container.decode(Bool.self, forKey: .isSelected)
    }
    
}

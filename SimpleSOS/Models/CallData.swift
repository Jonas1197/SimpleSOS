//
//  CallData.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 30/05/2021.
//

import UIKit

class CallData: Codable {
    var fullName: String
    var phoneNumber: String
    var time: String
    
    init() {
        let testing      = "[Testing]"
        self.fullName    = testing
        self.phoneNumber = testing
        self.time        = testing
    }
    
    init(fullName: String, phoneNumber: String, time: String) {
        self.fullName    = fullName
        self.phoneNumber = phoneNumber
        self.time        = time
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(time, forKey: .time)
    }

    required init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName    = try container.decode(String.self, forKey: .fullName)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.time  = try container.decode(String.self, forKey: .time)
    }
    
}

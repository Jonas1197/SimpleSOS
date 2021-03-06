//
//  Archiver.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 17/05/2021.
//

import Foundation

enum ContactType {
    case settingsContact, selectedContact, callData
}

final class Archiver {
   
    
    enum Directory: String {
        /// Variable.
        case contact, selectedContact, callData
        
        fileprivate var directoryURL: URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(rawValue)
        }
        
        static var root: URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }

    let directory: Directory
    
    init(directory: Directory) {
        self.directory = directory
    }

    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.directoryURL.appendingPathComponent(fn(key)).path)
    }
    
    public func put<T: Encodable>(_ item: T, forKey key: String) throws {
        if !FileManager.default.fileExists(atPath: directory.directoryURL.appendingPathComponent(directory.rawValue).path) {
            // Directory doesn't exist.
            try createDirectory(extension: directory.rawValue)
        }
        
        let data = try JSONEncoder().encode(item)
        let url = self.directory.directoryURL.appendingPathComponent(directory.rawValue).appendingPathComponent(fn(key))
        try data.write(to: url)
    }
    
    public func put(data: Data, forKey key: String) throws {
        if !FileManager.default.fileExists(atPath: directory.directoryURL.path) {
            // Directory doesn't exist.
            try createDirectory()
        }
        
        let url = self.directory.directoryURL.appendingPathComponent(fn(key))
        try data.write(to: url)
    }
    
    public func get<T: Decodable>(itemForKey key: String, ofType _: T.Type) -> T? {
        let url = self.directory.directoryURL.appendingPathComponent(fn(key))
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard T.self != Data.self else { return data as? T }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func deleteItem(forKey key: String) throws {
        let url = self.directory.directoryURL.appendingPathComponent(directory.rawValue).appendingPathComponent(fn(key))
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    public func all<T: Decodable>(_: T.Type) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: directory.directoryURL.appendingPathComponent(directory.rawValue), includingPropertiesForKeys: nil, options: [])
        return contents.compactMap {
            let data = try? Data(contentsOf: $0)
            return try? JSONDecoder().decode(T.self, from: data ?? Data())
        }
    }
    
    public func allFiles() throws -> [URL]? {
        try FileManager.default.contentsOfDirectory(at: directory.directoryURL.appendingPathComponent(directory.rawValue), includingPropertiesForKeys: nil, options: [])
    }
    
    public func removeAll() throws {
        let url = directory.directoryURL.appendingPathComponent(directory.rawValue)
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory(extension e: String? = nil) throws {
        try FileManager.default.createDirectory(atPath: directory.directoryURL.appendingPathComponent(e ?? "").path, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: - Top Level
    
    static func put<T: Encodable>(_ item: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(item)
        try data.write(to: Directory.root.appendingPathComponent(key))
    }
    
    static func get<T: Decodable>(itemForKey key: String, forType _: T.Type) -> T? {
        if let data = try? Data(contentsOf: Directory.root.appendingPathComponent(key)) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        
        return .none
    }
    
    static func deleteItem(forKey key: String) throws {
        let url = Directory.root.appendingPathComponent(key)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}


extension Archiver {
    public static func retrieveContacts<T>(of type: ContactType) -> [T]? {
        
        var data = [T]()
        
        switch type {
        case .settingsContact:
            guard let contacts = try? Archiver(directory: .contact).all(SSContact.self) else { return nil }
            data = contacts as! [T]
            break
            
        case .selectedContact:
            guard let contacts = try? Archiver(directory: .selectedContact).all(SSContact.self) else { return nil }
            data = contacts as! [T]
            break
            
        case .callData:
            guard let callData = try? Archiver(directory: .callData).all(CallData.self) else { return nil }
            data = callData as! [T]
            break
        }
        
        return data
        
//        let contactType = type == .settingsContact ? Directory.contact : Directory.selectedContact
//        if let contacts = try? Archiver(directory: contactType).all(SSContact.self) {
//            return contacts
//        } else {
//            print("Failed to fetch contacts or it might be nil.")
//            return [SSContact]()
//        }
    }

    
    public static func saveContacts(_ contacts: [SSContact]) {
        for contact in contacts {
            try? Archiver(directory: .contact).put(contact, forKey: contact.phoneNumber)
        }
    }
}

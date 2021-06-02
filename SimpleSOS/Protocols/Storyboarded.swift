//
//  Storyboarded.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}


extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let id = NSStringFromClass(self)
        let className = id.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
}

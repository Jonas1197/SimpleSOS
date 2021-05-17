//
//  EmergencyLabel.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

final class EmergencyLabel: UIView {
    
    public var text: String! {
        didSet {
            emergencyLabel.text = text
        }
    }
    
    public var emergencyMode: Bool! {
        didSet {
            emergencyMode ? (emergencyLabel.text = "SOS") : nil
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            if tintColor == .darkRed {
                
                emergencyLabel.textColor = tintColor
                firstWhiteLine.backgroundColor  = .white
                secondWhiteLine.backgroundColor = .white
            } else if tintColor == .white {
                emergencyLabel.textColor = tintColor
                firstWhiteLine.backgroundColor  = .darkRed
                secondWhiteLine.backgroundColor = .darkRed
            }
        }
    }
    
    private var firstWhiteLine: UIView = {
        let view             = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emergencyLabel: UILabel = {
        let label       = UILabel()
        label.text      = "Press here"
        label.textColor = .white
        label.font      = UIFont(name: Fonts.bold, size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var secondWhiteLine: UIView = {
        let view             = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var vstack: UIStackView = .init(
        axis: .vertical,
        spacing: 10,
        alignment: .fill,
        distribution: .fill,
        tamic: false)
    
    
    
    //MARK: - Main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    
    //MARK: - Body
    private func setUp() {
        configurevstack()
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configurevstack() {
        addSubview(vstack)
        vstack.addArrangedViews(views: firstWhiteLine, emergencyLabel, secondWhiteLine)
        NSLayoutConstraint.activate([
            vstack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vstack.centerXAnchor.constraint(equalTo: centerXAnchor),
            firstWhiteLine.heightAnchor.constraint(equalToConstant: 10),
            secondWhiteLine.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
}

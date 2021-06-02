//
//  MainTitleLabel.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

protocol MainTitleLabelDelegate {
    func shouldPresentEasterEgg() -> Void
}

class MainTitleLabel: UIView {

    var delegate: MainTitleLabelDelegate?
    
    public var text: String! {
        didSet {
            title.text = text
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            title.textColor           = tintColor
            whiteLine.backgroundColor = tintColor
        }
    }
    
    private var title: UILabel = {
        let label           = UILabel()
        label.text          = "Simple SOS"
        label.font          = UIFont(name: Fonts.bold, size: 22)
        label.textAlignment = .left
        label.textColor     = .white
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var whiteLine: UIView = {
        let view             = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    func fix(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
    
    
    
    //MARK: - Body
    
    private func setUp() {
        configureTitle()
        configureWhiteLine()
        setUpInteraction()
    }
    
    private func configureTitle() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor),
            title.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureWhiteLine() {
        whiteLine.fix(in: self, belowView: title, withTopPadding: 5, andHeight: 8)
    }
    
    private func setUpInteraction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        self.addGestureRecognizer(tap)
    }

    @objc private func titleTapped() {
        delegate?.shouldPresentEasterEgg()
    }
}

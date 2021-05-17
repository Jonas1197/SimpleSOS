//
//  EmergencyButton.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit

protocol EmergencyButtonDelegate {
    func didRequestEmergencyCall() -> Void
    
    func shouldPresentSettings() -> Void
    
    func shouldPresentEmergencyHistory() -> Void
}

class EmergencyButton: UIView {

    var delegate: EmergencyButtonDelegate?
    
    var maxY: CGFloat = 0
    
    private var guidanceLabel: UILabel = {
        let label       = UILabel()
        label.text      = "In case of an emergency tap below"
        label.font      = UIFont(name: Fonts.italic, size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var outerCircle: UIView = {
        let view             = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var innerCircle: UIView = {
        let view             = UIView()
        view.backgroundColor = .softRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emergencyLabel: EmergencyLabel = .init()
    
    private var settingsButton: UIButton = {
        let button = UIButton()
        button.setSFSymbol(iconName: SFSymbol.settings, size: 28, weight: .semibold, scale: .medium, tintColor: .white, backgroundColor: .clear)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var historyButton: UIButton = {
        let button = UIButton()
        button.setSFSymbol(iconName: SFSymbol.history, size: 28, weight: .semibold, scale: .medium, tintColor: .white, backgroundColor: .clear)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var settingsLabel: UILabel = {
        let label       = UILabel()
        label.text      = "Settings"
        label.font      = UIFont(name: Fonts.italic, size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var historyLabel: UILabel = {
        let label       = UILabel()
        label.text      = "Histroy"
        label.font      = UIFont(name: Fonts.italic, size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var settingsvstack: UIStackView = {
        return .init(axis: .vertical, spacing: 5, alignment: .center, distribution: .fill, tamic: false)
    }()
    
    private var histroyvstack: UIStackView = {
        return .init(axis: .vertical, spacing: 5, alignment: .center, distribution: .fill, tamic: false)
    }()
    
    private var buttonshstack: UIStackView = {
        return .init(axis: .horizontal, spacing: 0, alignment: .fill, distribution: .equalSpacing, tamic: false)
    }()
    
    
    
    //MARK: - Main
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerCircle.layer.roundCorners(to: .rounded)
        innerCircle.layer.roundCorners(to: .rounded)
        innerCircle.addShadow(withOpactiy: 0.4, andColor: .black, andRadius: 10, andOffset: .zero)
        outerCircle.addShadow(withOpactiy: 0.4, andColor: .black, andRadius: 10, andOffset: .zero)
        outerCircle.layer.shadowOpacity = 0
    }
  
    
    
    //MARK: - Body
    
    private func setUp(){
        configureGuidenceLabel()
        configureOuterCircle()
        configureInnerCircle()
        configureEmergencyLabel()
        configureButtons()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureGuidenceLabel() {
        addSubview(guidanceLabel)
        NSLayoutConstraint.activate([
            guidanceLabel.topAnchor.constraint(equalTo: topAnchor),
            guidanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureOuterCircle() {
        addSubview(outerCircle)
        NSLayoutConstraint.activate([
            outerCircle.topAnchor.constraint(equalTo: guidanceLabel.bottomAnchor, constant: 15),
            outerCircle.centerXAnchor.constraint(equalTo: guidanceLabel.centerXAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 300),
            outerCircle.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureInnerCircle() {
        addSubview(innerCircle)
        NSLayoutConstraint.activate([
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 240),
            innerCircle.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(emergencyButtonTapped))
        innerCircle.addGestureRecognizer(tap)
        
    }
    
    private func configureEmergencyLabel() {
        innerCircle.addSubview(emergencyLabel)
        NSLayoutConstraint.activate([
            emergencyLabel.centerXAnchor.constraint(equalTo: innerCircle.centerXAnchor),
            emergencyLabel.centerYAnchor.constraint(equalTo: innerCircle.centerYAnchor)
        ])
    }
    
    private func configureButtons() {
        settingsvstack.addArrangedViews(views: settingsButton, settingsLabel)
        histroyvstack.addArrangedViews(views: historyButton, historyLabel)
        buttonshstack.addArrangedViews(views: histroyvstack, settingsvstack)
        
        addSubview(buttonshstack)
        NSLayoutConstraint.activate([
            buttonshstack.leadingAnchor.constraint(equalTo: outerCircle.leadingAnchor, constant: 10),
            buttonshstack.trailingAnchor.constraint(equalTo: outerCircle.trailingAnchor, constant: -10),
            buttonshstack.topAnchor.constraint(equalTo: outerCircle.bottomAnchor, constant: 14)
        ])
        
        historyButton.addTarget(self, action: #selector(histroyButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
      
    }
    

    private func animateButtonTapped() {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .allowUserInteraction, .curveEaseInOut, .autoreverse], animations: { [weak self] in
            guard let self = self else { return }
            
            self.innerCircle.backgroundColor = .darkRed
            self.innerCircle.backgroundColor = .white
            
            if self.innerCircle.backgroundColor == .darkRed {
                self.emergencyLabel.tintColor = .white
            } else {
                self.emergencyLabel.tintColor = .darkRed
            }
            
            self.innerCircle.layer.shadowOpacity = 0
            self.innerCircle.layer.shadowOpacity = 0.4
            
            self.outerCircle.layer.shadowOpacity = 0.4
            self.outerCircle.layer.shadowOpacity = 0
            
        }, completion: nil)
    }
    
    
    //MARK: - Objc
    @objc private func emergencyButtonTapped() {
        animateButtonTapped()
        emergencyLabel.emergencyMode = true
        delegate?.didRequestEmergencyCall()
    }
    
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        delegate?.shouldPresentSettings()
    }
    
    @objc private func histroyButtonTapped(_ sender: UIButton) {
        delegate?.shouldPresentEmergencyHistory()
    }

}

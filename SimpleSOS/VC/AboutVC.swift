//
//  AboutVC.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 30/05/2021.
//

import UIKit

class AboutVC: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    private let mainTitle = MainTitleLabel()
    
    private var aboutTextView: UITextView = {
        let textView             = UITextView()
        textView.textColor       = .white
        textView.text            = About.text
        textView.font            = UIFont(name: Fonts.regualr, size: 18)
        textView.textAlignment   = .natural
        textView.isEditable      = false
        textView.isSelectable    = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    //MARK: - Body
    private func setUp() {
        view.backgroundColor = .softRed
        configureMainTitle()
        configureAboutTextView()
    }
    
    private func configureMainTitle() {
        mainTitle.add(to: self)
        mainTitle.text = "About"
    }
    
    private func configureAboutTextView() {
        view.addSubview(aboutTextView)
        NSLayoutConstraint.activate([
            aboutTextView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 20),
            aboutTextView.leadingAnchor.constraint(equalTo: mainTitle.leadingAnchor),
            aboutTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            aboutTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }


}

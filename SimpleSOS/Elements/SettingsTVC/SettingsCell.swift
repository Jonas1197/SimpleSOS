//
//  SettingsCell.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 12/05/2021.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func settingsCellHasChangedToggleStatus(for contact: SSContact) -> Void
}

class SettingsCell: UITableViewCell {

    weak var delegate: SettingsCellDelegate?
    
    public static let newCellIdentifier = "addCell"
    
    public static let reusIdentifier = "cell"
    
    public static let nib = UINib(nibName: "SettingsCell", bundle: nil)
    
    public var titleTintColot: UIColor! {
        didSet {
            title?.textColor = titleTintColot
        }
    }
    
    public var contact: SSContact! {
        didSet {
            title?.text = contact.fullName
        }
    }
    
    public var isToggled: Bool! {
        didSet {
            toggle?.isOn = isToggled
        }
    }
    
    @IBOutlet private var title: UILabel?
    
    @IBOutlet private var toggle: UISwitch?
    
    @IBOutlet private var vstack: UIStackView?
    
    private var newTitle: UILabel = {
        let label           = UILabel()
        label.text          = "Add"
        label.font          = UIFont(name: Fonts.italic, size: 18)
        label.textAlignment = .center
        label.textColor     = .init(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newImageView: UIImageView = {
        let imageView         = UIImageView()
        let configuration     = UIImage.SymbolConfiguration(pointSize: 18)
        imageView.image       = UIImage(systemName: SFSymbol.plus, withConfiguration: configuration)?.withTintColor(.init(white: 1, alpha: 0.5), renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let newvstack = UIStackView(axis: .vertical, spacing: 0, alignment: .fill, distribution: .fillProportionally, tamic: false)

    
    //MARK: - Main
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(for contact: SSContact) {
        self.contact         = contact
        self.titleTintColot  = .white
        self.backgroundColor = .clear
        self.toggle?.isOn    = contact.isSelected
        
        if contact.phoneNumber == SettingsCell.newCellIdentifier {
            vstack?.isHidden = true
            configureNewvstack()
        } else {
            vstack?.isHidden   = false
            newvstack.isHidden = true
        }
    }
    
    private func configureNewvstack() {
        newvstack.addArrangedViews(views: newImageView, newTitle)
        newvstack.fix(in: self, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toggleDidChange(_ sender: UISwitch) {
        print("\(contact.fullName): \(sender.isOn ? "On" : "Off")")
        contact.isSelected.toggle()
        delegate?.settingsCellHasChangedToggleStatus(for: contact)
    }
}

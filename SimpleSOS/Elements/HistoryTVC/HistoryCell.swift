//
//  HistoryCell.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 29/05/2021.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    func cellTapped()
}

class HistoryCell: UITableViewCell {

    weak var delegate: HistoryCellDelegate?
    
    static let cellIdentifier = "historyCell"
    
    static let nib = UINib(nibName: "HistoryCell", bundle: nil)
    
    var data: CallData? {
        didSet {
            configure(with: data)
        }
    }
    
    
    
    @IBOutlet private var nameLabel: UILabel?
    
    @IBOutlet private var phoneNumberLabel: UILabel?
    
    @IBOutlet private var timeLabel: UILabel?
    
    
    //MARK: - Main
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with data: CallData?) {
        guard let data         = data else { return }
        backgroundColor        = .clear
        nameLabel?.text        = data.fullName
        phoneNumberLabel?.text = data.phoneNumber
        timeLabel?.text        = "at \(data.time)"
        
        nameLabel?.textColor        = .white
        phoneNumberLabel?.textColor = .white
        timeLabel?.textColor        = .white
    }
}

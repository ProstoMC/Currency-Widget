//
//  SettingsTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 28.12.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //setupUI()
    }
}

// MARK:  - SETUP UI
extension SettingsTableViewCell {
    private func setupUI() {
        
        contentView.backgroundColor = Theme.Color.background
        self.selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width / 25),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.bounds.width / 25),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ])
        
        nameLabel.textColor = Theme.Color.mainText
        valueLabel.textColor = Theme.Color.secondText
        
        valueLabel.textAlignment = .right
        
    }
}

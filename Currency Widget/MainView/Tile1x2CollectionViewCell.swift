//
//  TileCellCollectionViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 13.10.2023.
//

import UIKit

class Tile1x2CollectionViewCell: UICollectionViewCell {
    
    let logoView = UIView()
    let shortNameLabel = UILabel()
    let valueLabel = UILabel()
    let additionalLabel1 = UILabel()
    let additionalLabel2 = UILabel()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    private func setupUI() {
        contentView.backgroundColor = .darkGray
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.brown.cgColor
        setupLogo()
        setupShortNameLabel()
        setupValueLabel()
        setupAdditionalLabels()
    }
    
    private func setupLogo() {
        contentView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        logoView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.bounds.height/10),
            logoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.height/12),
            logoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            logoView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ])
    
        //logoImage.layer.cornerRadius = logoImage.bounds.height / 2

        let label = UILabel()
        logoView.addSubview(label)
        label.text = "\u{20BE}"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(100) //Just set max and resize after
        label.adjustsFontSizeToFitWidth = true
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            label.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8),
            label.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8)
        ])
        
        self.layoutIfNeeded()  // For making corner radius
        
        self.logoView.layer.masksToBounds = true
        self.logoView.layer.cornerRadius = logoView.bounds.height/2
        
    }
    
    private func setupShortNameLabel() {
        contentView.addSubview(shortNameLabel)
        shortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shortNameLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            shortNameLabel.heightAnchor.constraint(equalToConstant: contentView.bounds.height*0.3),
            shortNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height*0.05),
            shortNameLabel.widthAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1.2),
        ])
        
        shortNameLabel.text = "GEL"
        shortNameLabel.font = shortNameLabel.font.withSize(100) //Just set max and resize after
        shortNameLabel.adjustsFontSizeToFitWidth = true
        shortNameLabel.textAlignment = .center
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentView.bounds.height*0.1),
            valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4 ),
            valueLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.5),
        ])
        
        valueLabel.text = "3.56\u{24}"
        valueLabel.font = valueLabel.font.withSize(100) //Just set max and resize after
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .right
    }
    private func setupAdditionalLabels() {
        contentView.addSubview(additionalLabel1)
        contentView.addSubview(additionalLabel2)
        additionalLabel1.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel2.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            additionalLabel1.rightAnchor.constraint(equalTo: valueLabel.rightAnchor),
            additionalLabel1.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            //additionalLabel1.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: contentView.bounds.height*0.05),
            additionalLabel1.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.5),
            
            additionalLabel2.rightAnchor.constraint(equalTo: valueLabel.rightAnchor),
            additionalLabel2.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.15),
            additionalLabel2.topAnchor.constraint(equalTo: additionalLabel1.bottomAnchor, constant: contentView.bounds.height*0.05),
            additionalLabel2.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.5),
            additionalLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height*0.08), //For visual equal with shortNameLabel
            
        ])
        
        additionalLabel1.text = "1\u{20BE} = 3.56\u{24}"
        additionalLabel2.text = "2\u{20BE} = 7.12\u{24}"
        
        
        additionalLabel1.font = additionalLabel1.font.withSize(100) //Just set max and resize after
        additionalLabel1.adjustsFontSizeToFitWidth = true
        additionalLabel1.textAlignment = .right
        additionalLabel1.textColor = .gray
        
        additionalLabel2.font = additionalLabel2.font.withSize(100) //Just set max and resize after
        additionalLabel2.adjustsFontSizeToFitWidth = true
        additionalLabel2.textAlignment = .right
        additionalLabel2.textColor = .gray

    }
    
}

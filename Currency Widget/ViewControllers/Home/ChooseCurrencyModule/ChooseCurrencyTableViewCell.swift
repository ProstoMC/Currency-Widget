//
//  ChooseCurrencyTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.
//

import UIKit

class ChooseCurrencyTableViewCell: UITableViewCell {
    
    let backgroundWhiteView = UIView()
    let logoView = UIView()
    let logoLabel = UILabel()
    
    let nameLabel = UILabel()
    
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
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(shortName: String, fullname: String, logo: String) {
        logoLabel.text = logo
        
        let name = "\(shortName) - \(fullname)"
        nameLabel.text = name
    }

}

// MARK:  - SETUP UI
extension ChooseCurrencyTableViewCell {
    private func setupUI() {
        
        contentView.backgroundColor = Theme.Color.background
        backgroundWhiteView.backgroundColor = .white
        
        contentView.addSubview(backgroundWhiteView)
        backgroundWhiteView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = Int(contentView.bounds.height*0.9) //I dont know why it should be more then contentView size
        //print("self = \(contentView.bounds.height) |  height = \(height)")
        
        NSLayoutConstraint.activate([
            backgroundWhiteView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundWhiteView.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            backgroundWhiteView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundWhiteView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        layoutIfNeeded()
        backgroundWhiteView.layer.cornerRadius = backgroundWhiteView.bounds.height*0.33
        
        setupLogo()
        setupNameLabel()
    }
    
    private func setupLogo() {
        backgroundWhiteView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: backgroundWhiteView.centerYAnchor),
            logoView.leftAnchor.constraint(equalTo: backgroundWhiteView.leftAnchor, constant: self.bounds.height*0.15),
            logoView.heightAnchor.constraint(equalToConstant: CGFloat(Int(backgroundWhiteView.bounds.height*0.7))),
            logoView.widthAnchor.constraint(equalToConstant: CGFloat(Int(backgroundWhiteView.bounds.height*0.7)))
        ])
    
        logoView.addSubview(logoLabel)
        logoLabel.text = "\u{00A4}"
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.font = logoLabel.font.withSize(100) //Just set max and resize after
        logoLabel.adjustsFontSizeToFitWidth = true
        logoLabel.textColor = Theme.Color.invertedText
        
        NSLayoutConstraint.activate([
            logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8),
            logoLabel.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8)
        ])
        
        self.layoutIfNeeded()  // For making corner radius
        
        self.logoView.layer.masksToBounds = true
        self.logoView.layer.cornerRadius = logoView.bounds.height/2
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1 )
        gradientLayer.frame = logoView.bounds
        gradientLayer.colors = [Theme.Color.mainColor.cgColor, Theme.Color.mainColor.withAlphaComponent(0.8).cgColor]
        logoView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setupNameLabel() {
        
        backgroundWhiteView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height*0.4),
            nameLabel.widthAnchor.constraint(equalTo: backgroundWhiteView.widthAnchor, multiplier: 0.7),
            nameLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: self.bounds.height*0.15),
            nameLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
        ])
        
        nameLabel.text = "GEL - Georgian Lari"
        nameLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .left
        nameLabel.textColor = Theme.Color.secondText
    
    }
    
}

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
    let logoImageView = UIImageView()
    
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
    
    func configure(coin: CurrencyCellViewModel) {
        configureLogo(coin: coin)
        //Color logo View
        colorsUpdate(colorSet: coin.colorSet)
        
        let name = "\(coin.code) - \(coin.name)"
        nameLabel.text = name
    }
    
    func configureLogo(coin: CurrencyCellViewModel){
        if coin.type == .fiat {
            logoImageView.isHidden = true
            logoLabel.text = coin.logo
            if coin.colorIndex >= 0 && coin.colorIndex < coin.colorSet.currencyColors.count {
                logoLabel.textColor = coin.colorSet.mainText
                logoView.backgroundColor = coin.colorSet.currencyColors[coin.colorIndex].withAlphaComponent(0.3)
            } else {
                logoLabel.textColor = coin.colorSet.tabBarBackground
                logoView.backgroundColor = coin.colorSet.tabBarBackground.withAlphaComponent(0.3)
            }
        } else {
            guard let url = URL(string: coin.imageUrl ?? "Error") else {
                print ("\(coin.code) : \(coin.imageUrl ?? "No image for")")
                logoImageView.isHidden = true
                logoLabel.text = coin.logo
                return
            }
            logoLabel.text = ""
            logoImageView.isHidden = false
            logoView.backgroundColor = backgroundView?.backgroundColor
            let placeHolder = UIImage(systemName: "gyroscope")
            
            logoImageView.sd_setImage(with: url, placeholderImage: placeHolder)
            logoImageView.tintColor = coin.colorSet.tabBarBackground
        }
    }

}

// MARK:  - SETUP UI
extension ChooseCurrencyTableViewCell {
    private func setupUI() {
        
        
        
        
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
    
    private func colorsUpdate(colorSet: AppColors) {
        contentView.backgroundColor = colorSet.background
        backgroundWhiteView.backgroundColor = colorSet.backgroundForWidgets
        nameLabel.textColor = colorSet.secondText
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
        
        
        NSLayoutConstraint.activate([
            logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.7),
            logoLabel.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.7)
        ])
        
        self.layoutIfNeeded()  // For making corner radius
        
        self.logoView.layer.masksToBounds = true
        self.logoView.layer.cornerRadius = logoView.bounds.height/2
        
        logoView.addSubview(logoImageView)
        logoImageView.frame = logoView.bounds
        
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
        
    
    }
    
}

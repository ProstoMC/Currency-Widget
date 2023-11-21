//
//  LabelBaseCurrency.swift
//  Currency Widget
//
//  Created by macSlm on 04.10.2023.
//

import UIKit

class MainNavigationBar: UINavigationBar {
    
    let logoImageView = UIImageView()
    let baseCurrencyLabel = UILabel()
    let baseCurrencyButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    private func setup() {
        self.backgroundColor = Theme.Color.backgroundForWidgets
        
        setupLogo()
        setupBaseCurrency()

    }
    
    private func setupLogo() {
        self.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: self.bounds.height*0.7),
            logoImageView.widthAnchor.constraint(equalToConstant: self.bounds.height*0.7),
            logoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.bounds.width / 25),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.layoutIfNeeded()
        //Apperance
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = logoImageView.bounds.height/2
        logoImageView.backgroundColor = Theme.Color.mainColor
        
    }
    
    private func setupBaseCurrency() {
        
        self.addSubview(baseCurrencyButton)
        self.addSubview(baseCurrencyLabel)
        
        baseCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        baseCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Layout

        NSLayoutConstraint.activate([
            //Button
            baseCurrencyButton.heightAnchor.constraint(equalToConstant: self.bounds.height*0.3),
            baseCurrencyButton.widthAnchor.constraint(equalToConstant: self.bounds.height*0.75),
            baseCurrencyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.bounds.width/80),
            baseCurrencyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.bounds.width/80),
            //Label
            baseCurrencyLabel.centerYAnchor.constraint(equalTo: baseCurrencyButton.centerYAnchor),
            baseCurrencyLabel.rightAnchor.constraint(equalTo: baseCurrencyButton.leftAnchor)
        ])
        
        //Apperance
        
        baseCurrencyButton.setTitle("USD", for: .normal)
        baseCurrencyButton.titleLabel?.font = baseCurrencyButton.titleLabel?.font.withSize(self.bounds.height/4)
        baseCurrencyButton.setTitleColor(Theme.Color.mainText, for: .normal)
        
        baseCurrencyButton.layer.borderColor = Theme.Color.mainText.cgColor
        baseCurrencyButton.layer.borderWidth = 2
        baseCurrencyButton.layer.cornerRadius = self.bounds.height*0.1   // Height / 3
        
        
        
        baseCurrencyLabel.text = "currency: "
        baseCurrencyLabel.font = baseCurrencyLabel.font.withSize(self.bounds.height/5)
        
        
    }

}

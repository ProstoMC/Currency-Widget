//
//  LabelBaseCurrency.swift
//  Currency Widget
//
//  Created by macSlm on 04.10.2023.
//

import UIKit

class MainNavigationBar: UINavigationBar {
    
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
        self.backgroundColor = Theme.Color.naviBar
        
        setupBaseCurrency()

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
        baseCurrencyButton.setTitleColor(Theme.Color.background, for: .normal)
        
        baseCurrencyButton.layer.borderColor = Theme.Color.background.cgColor
        baseCurrencyButton.layer.borderWidth = 2
        baseCurrencyButton.layer.cornerRadius = self.bounds.height*0.1   // Height / 3
        
        
        
        baseCurrencyLabel.text = "currency: "
        baseCurrencyLabel.font = baseCurrencyLabel.font.withSize(self.bounds.height/5)
        
        
    }

}
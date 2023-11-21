//
//  EnterCurrencyView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit

class EnterCurrencyView: UIView {
    
    let header = UILabel()
    let textField = UITextField()
    let separatorView = UIView()
    let currencyButton = UIButton()
    let chevronView = UIView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupUI()
    }
    

}

extension EnterCurrencyView {
    private func setupUI() {
        
        setupTextField()
        setupHeader()
        setupSeparator()
        setupCurrencyButton()
        setupChevron()
    }
    
    private func setupTextField() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65)
        ])
        
        //textField.delegate = self
        textField.layer.cornerRadius = Theme.Radius.minimal
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Theme.Color.separator.cgColor
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.backgroundColor = Theme.Color.backgroundForWidgets
    }
    
    private func setupHeader() {
        self.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.leftAnchor.constraint(equalTo: self.leftAnchor),
            header.rightAnchor.constraint(equalTo: self.rightAnchor),
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
        
        header.text = "From"
        header.font = UIFont.systemFont(ofSize: 100, weight: .regular) //Just set max and resize after
        
        header.adjustsFontSizeToFitWidth = true
        header.textAlignment = .left
        header.textColor = Theme.Color.secondText
    }
    
    private func setupSeparator() {
        self.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: UIScreen.main.bounds.width*0.1),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            separatorView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            separatorView.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 0.8)
        ])
        
        separatorView.backgroundColor = Theme.Color.separator
    }
    
    private func setupCurrencyButton() {
        self.addSubview(currencyButton)
        currencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currencyButton.leftAnchor.constraint(equalTo: separatorView.rightAnchor),
            currencyButton.rightAnchor.constraint(equalTo: textField.rightAnchor),
            currencyButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            currencyButton.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 0.8)
        ])
        
        currencyButton.setTitle(" lari", for: .normal)
        currencyButton.setTitleColor(Theme.Color.mainColor, for: .normal)
        currencyButton.contentHorizontalAlignment = .left

    }
    
    private func setupChevron() {
        self.addSubview(chevronView)
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevronView.rightAnchor.constraint(equalTo: textField.rightAnchor),
            chevronView.widthAnchor.constraint(equalTo: textField.heightAnchor),
            chevronView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            chevronView.heightAnchor.constraint(equalTo: textField.heightAnchor)
        ])
        
        let chevronImageView = UIImageView()
        chevronView.addSubview(chevronImageView)
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chevronImageView.centerXAnchor.constraint(equalTo: chevronView.centerXAnchor),
            chevronImageView.widthAnchor.constraint(equalTo: chevronView.widthAnchor, multiplier: 0.5),
            chevronImageView.centerYAnchor.constraint(equalTo: chevronView.centerYAnchor),
            chevronImageView.heightAnchor.constraint(equalTo: chevronView.heightAnchor, multiplier: 0.5)
        ])
        
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = Theme.Color.mainColor
        chevronImageView.contentMode = .scaleAspectFit

    }
    
    
  
}

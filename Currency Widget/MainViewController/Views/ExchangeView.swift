//
//  ExchangeView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit

class ExchangeView: UIViewController {
    
    let exchangeLabel = UILabel()
    let changeButton = UIButton()
    
    let fromView = EnterCurrencyView()
    let toView = EnterCurrencyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}
// MARK:  - SETUP UI
extension ExchangeView {
    private func setupUI() {
        
        //self.backgroundColor = .yellow
        setupChangeButton()
        setupHeader()
        setupFromView()
        setupToView()
    }
    
    private func setupChangeButton() {
        self.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            changeButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2),
            changeButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            changeButton.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        self.layoutIfNeeded()
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = Theme.Radius.minimal
        changeButton.backgroundColor = Theme.Color.mainColorPale
        changeButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        changeButton.imageView?.tintColor = Theme.Color.mainColor

        changeButton.imageView?.contentMode = .scaleAspectFill

    }
    
    
    
    private func setupHeader() {
        self.addSubview(exchangeLabel)
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            exchangeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:0.75),
            exchangeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            exchangeLabel.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor),
        ])
        
        exchangeLabel.text = "Exchange"
        exchangeLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        
        exchangeLabel.adjustsFontSizeToFitWidth = true
        exchangeLabel.textAlignment = .left
        exchangeLabel.textColor = Theme.Color.mainText
        //exchangeLabel.backgroundColor = .white
        
        
    }
    
    private func setupFromView() {
        self.addSubview(fromView)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fromView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            fromView.leftAnchor.constraint(equalTo: self.leftAnchor),
            fromView.rightAnchor.constraint(equalTo: self.rightAnchor),
            fromView.topAnchor.constraint(equalTo: changeButton.bottomAnchor, constant: self.bounds.height*0.1),
        ])
    }
    private func setupToView() {
        self.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            toView.leftAnchor.constraint(equalTo: self.leftAnchor),
            toView.rightAnchor.constraint(equalTo: self.rightAnchor),
            toView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}

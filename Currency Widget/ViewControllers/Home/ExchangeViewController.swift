//
//  ExchangeView.swift
//  Currency Widget
//
//  Created by macSlm on 14.11.2023.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    let exchangeLabel = UILabel()
    let changeButton = UIButton()
    
    let fromView = EnterCurrencyView()
    let toView = EnterCurrencyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .yellow
        setupUI()
    }

}

// MARK:  - SETUP UI
extension ExchangeViewController {
    private func setupUI() {
        
        //self.backgroundColor = .yellow
        setupChangeButton()
        setupHeader()
        setupFromView()
        setupToView()
    }
    
    private func setupChangeButton() {
        view.addSubview(changeButton)
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18),
            changeButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            changeButton.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        view.layoutIfNeeded()
        changeButton.clipsToBounds = true
        changeButton.layer.cornerRadius = Theme.Radius.minimal
        changeButton.backgroundColor = Theme.Color.mainColorPale
        changeButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        changeButton.imageView?.tintColor = Theme.Color.mainColor.withAlphaComponent(0.4)
        changeButton.imageView?.contentMode = .scaleAspectFit

    }
    
    
    
    private func setupHeader() {
        view.addSubview(exchangeLabel)
        exchangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exchangeLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            exchangeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.75),
            exchangeLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
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
        view.addSubview(fromView)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fromView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            fromView.leftAnchor.constraint(equalTo: view.leftAnchor),
            fromView.rightAnchor.constraint(equalTo: view.rightAnchor),
            fromView.topAnchor.constraint(equalTo: changeButton.bottomAnchor), // 0.05 of view
        ])
    }
    private func setupToView() {
        view.addSubview(toView)
        toView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            toView.leftAnchor.constraint(equalTo: view.leftAnchor),
            toView.rightAnchor.constraint(equalTo: view.rightAnchor),
            toView.topAnchor.constraint(equalTo: fromView.bottomAnchor, constant: UIScreen.main.bounds.height*0.0125), // 0.05 of view
        ])
        toView.header.text = "To"
    }
    
}

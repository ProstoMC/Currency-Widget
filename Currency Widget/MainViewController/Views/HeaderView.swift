//
//  HeaderView.swift
//  Currency Widget
//
//  Created by macSlm on 13.11.2023.
//

import UIKit

class HeaderView: UIView {
    
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}
extension HeaderView {
    
    private func setup() {
        self.backgroundColor = Theme.Color.background
        setupLogo()
    }
    
    // MARK:  - Setup logo
    
    private func setupLogo() {
        self.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: self.bounds.height*0.75),
            logoImageView.widthAnchor.constraint(equalToConstant: self.bounds.height*0.75),
            logoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.bounds.width / 25),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        self.layoutIfNeeded()
        //Apperance
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = logoImageView.bounds.height/2
        logoImageView.backgroundColor = Theme.Color.mainColorPale
        
    }

}

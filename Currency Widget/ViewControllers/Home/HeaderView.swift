//
//  HeaderView.swift
//  Currency Widget
//
//  Created by macSlm on 13.11.2023.
//

import UIKit
import RxSwift

class HeaderView: UIView {
    
    let bag = DisposeBag()
    
    let logoImageView = UIImageView()
    let dateTextLabel = UILabel()
    
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
        setupTextField()
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
        logoImageView.image = UIImage(named: "LogoLightMode")
        logoImageView.contentMode = .scaleAspectFill
        
    }
    
    private func setupTextField() {
        self.addSubview(dateTextLabel)
        dateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateTextLabel.heightAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 0.4),
            dateTextLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            dateTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.bounds.width / 25),
            dateTextLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
        ])
      
   
        dateTextLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        dateTextLabel.adjustsFontSizeToFitWidth = true
        dateTextLabel.textAlignment = .right
        dateTextLabel.textColor = Theme.Color.secondText.withAlphaComponent(0.4)
        
        CoreWorker.shared.rxUptadingDate.subscribe{ updatingDate in
            self.dateTextLabel.text = "Actual to " + updatingDate
        }.disposed(by: bag)
        
    }

}

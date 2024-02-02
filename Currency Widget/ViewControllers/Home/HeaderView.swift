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
    let rxDate = BehaviorSubject(value: "No date")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        rxSubscribing()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        rxSubscribing()
    }
    
    private func rxSubscribing() {
        CoreWorker.shared.coinList.rxRateUpdated.subscribe(onNext: { _ in
            self.dateTextLabel.text = "Actual to " + CoreWorker.shared.coinList.lastUpdate
        }).disposed(by: bag)
        
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            UIView.animate(withDuration: 0.5, delay: 0.0,
                           options: [.allowUserInteraction], animations: { () -> Void in
                self.colorsUpdate()
            })
            
        }.disposed(by: bag)

    }
    
}
extension HeaderView {
    
    private func setup() {
        
        colorsUpdate()
        setupLogo()
        setupTextField()
    }
    
    private func colorsUpdate() {
        self.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().background
        logoImageView.backgroundColor = CoreWorker.shared.colorsWorker.returnColors().mainColorPale
        dateTextLabel.textColor = CoreWorker.shared.colorsWorker.returnColors().secondText.withAlphaComponent(0.4)
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
        

        
    }

}

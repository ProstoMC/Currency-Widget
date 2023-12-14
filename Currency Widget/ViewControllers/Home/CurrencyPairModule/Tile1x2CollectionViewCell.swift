//
//  TileCellCollectionViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 13.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class Tile1x2CollectionViewCell: UICollectionViewCell {
    
    var standartLayoutSpace: CGFloat!
    
    let logoView = UIView()
    let logoLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    let mainCurrencyNameLabel = UILabel()
    let baseCurrencyNameLabel = UILabel()
    
    let valueLabel = UILabel()
    
    let changesArrowImageView = UIImageView()
    let changesLabel = UILabel()
    let additionalLabel2 = UILabel()
    let graph = UIView()
    
    let disposeBag = DisposeBag()
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK:  - CONFIGURE RX
    
    func rxConfigure(currecnyPair: CurrencyPair) { //I know, it is not good way, but too late components
        logoLabel.text = currecnyPair.valueCurrencyLogo
        mainCurrencyNameLabel.text = currecnyPair.valueCurrencyShortName
        baseCurrencyNameLabel.text = "to \(currecnyPair.baseCurrencyShortName)"
        
        //Color of logo
        gradientLayer.colors = Theme.colorsForGradient[currecnyPair.colorIndex]
        
        //Setup Value Label
        currecnyPair.rxValue.subscribe(onNext: { value in
            
            let attributedText = NSMutableAttributedString(
                string: String(format: "%.2f", value),
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 100, weight: .medium)])
            
            attributedText.append(NSAttributedString(
                string: currecnyPair.baseLogo,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 70, weight: .light), NSAttributedString.Key.foregroundColor: Theme.Color.secondText.withAlphaComponent(0.8)]))
            
            self.valueLabel.attributedText = attributedText
            
        }).disposed(by: disposeBag)
        
        //Setup Changes Label
        currecnyPair.rxValueFlow.subscribe(onNext: { flow in
            self.changesLabel.text = String(format: "%.2f", flow) + currecnyPair.baseLogo
            
            if flow >= 0 {
                self.changesLabel.textColor = Theme.Color.green
                self.changesArrowImageView.tintColor = Theme.Color.green
                self.changesArrowImageView.image = UIImage(systemName: "arrow.up.right")
            } else {
                self.changesLabel.textColor = Theme.Color.red
                self.changesArrowImageView.tintColor = Theme.Color.red
                self.changesArrowImageView.image = UIImage(systemName: "arrow.down.right")
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    
    private func configureChangesLabel(rxValueFlow: BehaviorSubject<Double>, baseLogo: String){
        

    }
    
    
    
}

    // MARK:  - SETUP UI

extension Tile1x2CollectionViewCell {
    private func setupUI() {
        standartLayoutSpace = contentView.bounds.height/20
        
        contentView.backgroundColor = Theme.Color.backgroundForWidgets
        contentView.layer.cornerRadius = Theme.Radius.mainWidget
        setupLogo()
        setupShortNameLabel()
        setupValueLabel()
        setupChangesRow()
        
    }
    
    // MARK:  - SETUP LOGO
    private func setupLogo() {
        contentView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standartLayoutSpace*1.5),
            logoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: standartLayoutSpace*1.5),
            logoView.heightAnchor.constraint(equalToConstant: self.bounds.height*0.25),
            logoView.widthAnchor.constraint(equalToConstant: self.bounds.height*0.25)
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
        
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = logoView.bounds

        logoView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    // MARK:  - SETUP HEAD LABELS
    private func setupShortNameLabel() {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mainCurrencyNameLabel)
        stackView.addArrangedSubview(baseCurrencyNameLabel)
        
        mainCurrencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        baseCurrencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: standartLayoutSpace),
            stackView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            //shortNameLabel.bottomAnchor.constraint(equalTo: logoView.centerYAnchor),
            //shortNameLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: standartLayoutSpace),
            mainCurrencyNameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height*0.17),
            mainCurrencyNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            baseCurrencyNameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height*0.09),
            baseCurrencyNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            //baseCurrencyNameLabel.leftAnchor.constraint(equalTo: mainCurrencyNameLabel.leadingAnchor, constant: self.bounds.height*0.001)
        ])
        
        mainCurrencyNameLabel.text = "GEL"
        mainCurrencyNameLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        
        mainCurrencyNameLabel.adjustsFontSizeToFitWidth = true
        mainCurrencyNameLabel.textAlignment = .left
        mainCurrencyNameLabel.textColor = Theme.Color.mainText
        //mainCurrencyNameLabel.backgroundColor = Theme.Color.mainColorPale
        
        baseCurrencyNameLabel.text = "to USD"
        baseCurrencyNameLabel.font = UIFont.systemFont(ofSize: 100, weight: .regular) //Just set max and resize after
        
        baseCurrencyNameLabel.adjustsFontSizeToFitWidth = true
        baseCurrencyNameLabel.textAlignment = .left
        baseCurrencyNameLabel.textColor = Theme.Color.secondText
        //baseCurrencyNameLabel.backgroundColor = .yellow
        
    }
    
    // MARK:  - SETUP VALUE LABEL
    private func setupValueLabel() {
        
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.leftAnchor.constraint(equalTo: logoView.leftAnchor),
            valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            //valueLabel.bottomAnchor.constraint(equalTo: changesLabel.topAnchor, constant: -standartLayoutSpace),
            valueLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.8),
        ])
        
        valueLabel.text = "3.56\u{24}"
        valueLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .left
        valueLabel.textColor = Theme.Color.mainText
        
    }
    
    private func setupChangesRow() {
        
        contentView.addSubview(changesArrowImageView)
        contentView.addSubview(changesLabel)
        
        changesLabel.translatesAutoresizingMaskIntoConstraints = false
        changesArrowImageView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            changesArrowImageView.leftAnchor.constraint(equalTo: valueLabel.leftAnchor),
            changesArrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standartLayoutSpace*1.5),
            changesArrowImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1),
            changesArrowImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1),
            changesArrowImageView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: standartLayoutSpace/2),
            
            changesLabel.leftAnchor.constraint(equalTo: changesArrowImageView.rightAnchor),
            changesLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.12),
            changesLabel.bottomAnchor.constraint(equalTo: changesArrowImageView.bottomAnchor),
            changesLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.6),
            
        ])
        
        changesArrowImageView.image = UIImage(systemName: "arrow.up.right")
        changesArrowImageView.tintColor = .systemGreen
        changesArrowImageView.contentMode = .scaleAspectFit
        //changesArrowImageView.backgroundColor = .yellow
        
        changesLabel.text = " +0.05\u{24}"
        changesLabel.font = changesLabel.font.withSize(100) //Just set max and resize after
        changesLabel.adjustsFontSizeToFitWidth = true
        changesLabel.textAlignment = .left
        changesLabel.textColor = Theme.Color.green
        //changesLabel.backgroundColor = .lightGray
        

    }

}

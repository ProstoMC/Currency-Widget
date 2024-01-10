//
//  CurrencyListTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 04.12.2023.
//

import UIKit
import RxSwift
import RxDataSources

class CurrencyListTableViewCell: UITableViewCell {
    
    var standartLayoutSpace: CGFloat!
    
    let backgroundWhiteView = UIView()
    let logoView = UIView()
    let logoLabel = UILabel()
    
    
    let nameLabel = UILabel()
    
    let valueLabel = UILabel()
    let changesStackView = UIStackView()
    let changesArrowImageView = UIImageView()
    let changesLabel = UILabel()
    
    let favoriteButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    var baseName = ""
    var valueName = ""
    
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
        //setupUI()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:  - RX CONFIGURE
    func rxConfigure(currency: Currency, baseLogo: String) { //I know, it is not good way, but too late components
        valueName = currency.shortName
        baseName = currency.base
        
        logoLabel.text = currency.logo
       
        //Color logo View
        //gradientLayer.colors = Theme.currencyColors[currecnyPair.colorIndex]
        logoLabel.textColor = Theme.currencyColors[currency.colorIndex]
        logoView.backgroundColor = Theme.currencyColors[currency.colorIndex].withAlphaComponent(0.1)
        
        let name = "\(currency.shortName) - \(currency.name)"
        nameLabel.text = name
        
        //Setup Value Label
        currency.rateRx.subscribe(onNext: { value in
        
            let rate = String(format: "%.2f", value)
            self.valueLabel.text = "\(baseLogo) \(rate)"
            
        }).disposed(by: disposeBag)
        
        //Setup Changes Label
        currency.flowRateRx.subscribe(onNext: { flow in
            self.changesLabel.text = baseLogo + " " + String(format: "%.2f", flow) + " "
            
            if flow >= 0 {
                self.changesStackView.backgroundColor = Theme.Color.green
                
                self.changesArrowImageView.image = UIImage(systemName: "arrow.up.right")
            } else {
                self.changesStackView.backgroundColor = Theme.Color.red
                self.changesArrowImageView.image = UIImage(systemName: "arrow.down.right")
            }
            
        }).disposed(by: disposeBag)
        
        //Setup FavoriteButton
        CoreWorker.shared.rxFavouritPairsCount.subscribe{_ in
            let favoriteStatus = CoreWorker.shared.isPairExistInFavoriteList(
                valueName: self.valueName,
                baseName: self.baseName)
            if favoriteStatus {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
        }.disposed(by: disposeBag)

        //RX drive doesn't work in the cell. Using usual way
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        print(valueName)
        let favoriteStatus = CoreWorker.shared.isPairExistInFavoriteList(
            valueName: valueName,
            baseName: baseName)
        if favoriteStatus {
            CoreWorker.shared.deletePairFromFavoriteList(valueName: valueName, baseName: baseName)
        }
        else {
            CoreWorker.shared.addPairToFavoriteList(valueName: valueName, baseName: baseName)
        }
    }
}

    // MARK:  - SETUP UI

extension CurrencyListTableViewCell {
    private func setupUI() {
        
        
        contentView.backgroundColor = Theme.Color.background
        backgroundWhiteView.backgroundColor = .white
        
        contentView.addSubview(backgroundWhiteView)
        backgroundWhiteView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = Int(contentView.bounds.height*1.2) //I dont know why it should be more then contentView size
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
        setupValueLabel()
        setupChangesRow()
        setupFavoriteView()
        
    }
    
    // MARK:  - SETUP LOGO
    private func setupLogo() {
        backgroundWhiteView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: backgroundWhiteView.centerYAnchor),
            logoView.leftAnchor.constraint(equalTo: backgroundWhiteView.leftAnchor, constant: self.bounds.height*0.15),
            logoView.heightAnchor.constraint(equalToConstant: CGFloat(Int(backgroundWhiteView.bounds.height*0.75))),
            logoView.widthAnchor.constraint(equalToConstant: CGFloat(Int(backgroundWhiteView.bounds.height*0.75)))
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
            logoLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.6),
            logoLabel.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.6)
        ])
        
        self.layoutIfNeeded()  // For making corner radius
        
        self.logoView.layer.masksToBounds = true
        self.logoView.layer.cornerRadius = logoView.bounds.height/2
        
        
//        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.frame = logoView.bounds
//        logoView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    // MARK:  - SETUP HEAD LABELS
    private func setupNameLabel() {
        
        backgroundWhiteView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: self.bounds.height*0.3),
            nameLabel.widthAnchor.constraint(equalTo: backgroundWhiteView.widthAnchor, multiplier: 0.7),
            nameLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: self.bounds.height*0.15),
            nameLabel.topAnchor.constraint(equalTo: logoView.topAnchor),
        ])
        
        nameLabel.text = "GEL - Georgian Lari"
        nameLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium) //Just set max and resize after
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .left
        nameLabel.textColor = Theme.Color.secondText
    
    }
    
    // MARK:  - SETUP VALUE LABEL
    private func setupValueLabel() {
        
        backgroundWhiteView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: backgroundWhiteView.bounds.height*0.4),
            valueLabel.bottomAnchor.constraint(equalTo: logoView.bottomAnchor),
            //valueLabel.widthAnchor.constraint(equalToConstant: backgroundWhiteView.bounds.width*0.5),
        ])
        
        valueLabel.text = "3.56\u{24}"
        valueLabel.font = UIFont.systemFont(ofSize: backgroundWhiteView.bounds.height*0.45, weight: .medium)
        //valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .left
        valueLabel.textColor = Theme.Color.mainText
        valueLabel.sizeToFit()
    }
    
    private func setupChangesRow() {
        
        
        backgroundWhiteView.addSubview(changesStackView)
        changesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        changesStackView.addArrangedSubview(changesArrowImageView)
        changesStackView.addArrangedSubview(changesLabel)
        
        changesLabel.translatesAutoresizingMaskIntoConstraints = false
        changesArrowImageView.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            changesStackView.leftAnchor.constraint(equalTo: valueLabel.rightAnchor, constant: self.bounds.height*0.15),
            
            
            changesArrowImageView.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -backgroundWhiteView.bounds.height*0.05),
            changesArrowImageView.heightAnchor.constraint(equalTo: backgroundWhiteView.heightAnchor, multiplier: 0.25),
            changesArrowImageView.widthAnchor.constraint(equalTo: backgroundWhiteView.heightAnchor, multiplier: 0.25),
            
            //changesLabel.leftAnchor.constraint(equalTo: changesArrowImageView.rightAnchor),
            changesLabel.heightAnchor.constraint(equalTo: changesArrowImageView.heightAnchor),
            changesLabel.bottomAnchor.constraint(equalTo: changesArrowImageView.bottomAnchor),
            //changesLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.6),
            
        ])
        
        layoutIfNeeded()
        changesStackView.backgroundColor = Theme.Color.green
        changesStackView.layer.cornerRadius = changesStackView.bounds.height/2
        
        changesArrowImageView.image = UIImage(systemName: "arrow.up.right")
        changesArrowImageView.tintColor = Theme.Color.backgroundForWidgets
        changesArrowImageView.contentMode = .scaleAspectFit
        //changesArrowImageView.backgroundColor = .yellow
        
        changesLabel.text = " +0.05\u{24} "
        changesLabel.font = changesLabel.font.withSize(backgroundWhiteView.bounds.height*0.25)
        changesLabel.sizeToFit()
        //changesLabel.adjustsFontSizeToFitWidth = true
        changesLabel.textAlignment = .left
        changesLabel.textColor = Theme.Color.backgroundForWidgets
        //changesLabel.backgroundColor = .lightGray
        

    }
    
    private func setupFavoriteView() {
        backgroundWhiteView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.centerYAnchor.constraint(equalTo: backgroundWhiteView.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: backgroundWhiteView.rightAnchor, constant: -self.bounds.height*0.25),
            favoriteButton.heightAnchor.constraint(equalTo: backgroundWhiteView.heightAnchor, multiplier: 0.5),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor)
        ])
        
        favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        favoriteButton.contentMode = .scaleAspectFit
        favoriteButton.tintColor = Theme.Color.mainColor
    }

}


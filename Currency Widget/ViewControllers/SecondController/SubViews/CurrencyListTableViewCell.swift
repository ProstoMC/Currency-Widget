//
//  CurrencyListTableViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 04.12.2023.
//

import UIKit
import RxSwift
import RxDataSources
import SDWebImage

class CurrencyListTableViewCell: UITableViewCell {

    
    var standartLayoutSpace: CGFloat!
    
    let backgroundWhiteView = UIView()
    let logoView = UIView()
    let logoLabel = UILabel()
    let logoImageView = UIImageView()
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:  - RX CONFIGURE
    
    func configureWithUniversalCoin(coin: CurrencyCellViewModel) {
        configureLogo(coin: coin)
        
        valueName = coin.code
        baseName = coin.baseCode
        
        nameLabel.text = coin.name
        
        let rate = String(format: "%.2f", coin.rate)
        //self.valueLabel.text = "\(baseLogo) \(rate)"
        self.valueLabel.text = "\(coin.baseLogo) \(rate)"
        
        let flow = String(format: "%.3f", coin.flow)
        changesLabel.text = coin.baseLogo + " " + flow + " "
        
        if coin.flow >= 0 {
            self.changesStackView.backgroundColor = Theme.Color.green
            
            self.changesArrowImageView.image = UIImage(systemName: "arrow.up.right")
        } else {
            self.changesStackView.backgroundColor = Theme.Color.red
            self.changesArrowImageView.image = UIImage(systemName: "arrow.down.right")
        }
        
        setupButton(isfavorite: coin.isFavorite)

    }
    
    func setupButton(isfavorite: Bool) {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        if isfavorite {
            favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
        
        CoreWorker.shared.favouritePairList.rxPairListCount.subscribe { _ in
            let isExist = CoreWorker.shared.favouritePairList.checkIsExist(valueCode: self.valueName, baseCode: self.baseName)
            if isExist {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
        }.disposed(by: disposeBag)
        
    }
    
    func configureLogo(coin: CurrencyCellViewModel){
        if coin.type == .fiat {
            logoImageView.isHidden = true
            logoLabel.text = coin.logo
            if coin.colorIndex >= 0 && coin.colorIndex < Theme.currencyColors.count {
                logoLabel.textColor = Theme.currencyColors[coin.colorIndex]
                logoView.backgroundColor = Theme.currencyColors[coin.colorIndex].withAlphaComponent(0.1)
            } else {
                logoLabel.textColor = Theme.Color.tabBarBackground
                logoView.backgroundColor = Theme.Color.tabBarBackground.withAlphaComponent(0.1)
            }
        } else {
            guard let url = URL(string: coin.imageUrl ?? "Error") else {
                print ("\(coin.code) : \(coin.imageUrl ?? "No image for")")
                logoImageView.isHidden = true
                logoLabel.text = coin.logo
                return
            }
            logoLabel.text = ""
            logoImageView.isHidden = false
            logoView.backgroundColor = backgroundView?.backgroundColor
            let placeHolder = UIImage(systemName: "gyroscope")
            
            logoImageView.sd_setImage(with: url, placeholderImage: placeHolder)
            logoImageView.tintColor = Theme.Color.tabBarBackground
        }
        
        
    }
    
    @objc private func favoriteButtonTapped() {
        print(valueName)
        let favoriteStatus = CoreWorker.shared.favouritePairList.checkIsExist(valueCode: valueName, baseCode: baseName)
        if favoriteStatus {
            CoreWorker.shared.favouritePairList.deletePair(valueCode: valueName, baseCode: baseName)
        }
        else {
            let colorIndex = CoreWorker.shared.favouritePairList.pairList.count % Theme.currencyColors.count
            CoreWorker.shared.favouritePairList.addNewPair(valueCode: valueName, baseCode: baseName, colorIndex: colorIndex)
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
        
        logoView.addSubview(logoImageView)
        logoImageView.frame = logoView.bounds
        
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


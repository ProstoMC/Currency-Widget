//
//  TileCellCollectionViewCell.swift
//  Currency Widget
//
//  Created by macSlm on 13.10.2023.
//

import UIKit

class Tile1x2CollectionViewCell: UICollectionViewCell {
    
    var standartLayoutSpace: CGFloat!
    
    let logoView = UIView()
    let logoLabel = UILabel()
    let shortNameLabel = UILabel()
    let valueLabel = UILabel()
    let additionalLabel1 = UILabel()
    let additionalLabel2 = UILabel()
    let graph = UIView()
    
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(shortName: String, logo: String, value: Double, base: String){
        logoLabel.text = logo
        shortNameLabel.text = shortName
        let strValue = String(Double(round(100 * 1/value) / 100))
        valueLabel.text = strValue + base
        
    }
    
    
    private func setupUI() {
        standartLayoutSpace = contentView.bounds.height/20
        

        
        
        contentView.backgroundColor = Theme.Color.background
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Theme.Color.border.cgColor
        setupLogo()
        setupShortNameLabel()
        setupValueLabel()
        setupAdditionalLabels()
        setupGraph()
    }
    
    private func setupLogo() {
        contentView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standartLayoutSpace),
            logoView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: standartLayoutSpace),
            logoView.heightAnchor.constraint(equalToConstant: standartLayoutSpace*4.5),
            logoView.widthAnchor.constraint(equalToConstant: standartLayoutSpace*4.5)
        ])
    
        

        
        logoView.addSubview(logoLabel)
        logoLabel.text = "\u{00A4}"
        logoLabel.textAlignment = .center
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.font = logoLabel.font.withSize(100) //Just set max and resize after
        logoLabel.adjustsFontSizeToFitWidth = true
        logoLabel.textColor = Theme.Color.mainText
        
        NSLayoutConstraint.activate([
            logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor),
            logoLabel.heightAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8),
            logoLabel.widthAnchor.constraint(equalTo: logoView.heightAnchor, multiplier: 0.8)
        ])
        
        self.layoutIfNeeded()  // For making corner radius
        
        self.logoView.layer.masksToBounds = true
        self.logoView.layer.cornerRadius = logoView.bounds.height/2
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = logoView.bounds
        gradientLayer.colors = [Theme.Color.border.cgColor, Theme.Color.background.cgColor]
        logoView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    private func setupShortNameLabel() {
        contentView.addSubview(shortNameLabel)
        shortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shortNameLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor),
            shortNameLabel.heightAnchor.constraint(equalToConstant: standartLayoutSpace*3),
            shortNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -standartLayoutSpace),
            shortNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
        ])
        
        shortNameLabel.text = "GEL"
        shortNameLabel.font = shortNameLabel.font.withSize(100) //Just set max and resize after
        shortNameLabel.adjustsFontSizeToFitWidth = true
        shortNameLabel.textAlignment = .right
        valueLabel.textColor = Theme.Color.mainText
    }
    
    private func setupValueLabel() {
        contentView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.rightAnchor.constraint(equalTo: shortNameLabel.rightAnchor),
            valueLabel.heightAnchor.constraint(equalTo: shortNameLabel.heightAnchor ),
            valueLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.6),
        ])
        
        valueLabel.text = "3.56\u{24}"
        valueLabel.font = valueLabel.font.withSize(100) //Just set max and resize after
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.textAlignment = .right
        valueLabel.textColor = Theme.Color.mainText
        
    }
    
    private func setupAdditionalLabels() {
        contentView.addSubview(additionalLabel1)
        contentView.addSubview(additionalLabel2)
        additionalLabel1.translatesAutoresizingMaskIntoConstraints = false
        additionalLabel2.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            additionalLabel1.rightAnchor.constraint(equalTo: valueLabel.rightAnchor),
            additionalLabel1.heightAnchor.constraint(equalToConstant: standartLayoutSpace*1.5),
            additionalLabel1.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: standartLayoutSpace*0.5),
            additionalLabel1.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.8),
            
            additionalLabel2.rightAnchor.constraint(equalTo: valueLabel.rightAnchor),
            additionalLabel2.heightAnchor.constraint(equalToConstant: standartLayoutSpace*1.5),
            additionalLabel2.topAnchor.constraint(equalTo: additionalLabel1.bottomAnchor, constant: standartLayoutSpace*0.5),
            additionalLabel2.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.8),
            //additionalLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height*0.08), //For visual equal with shortNameLabel
            
        ])
        
        additionalLabel1.text = "1\u{20BE} = 3.56\u{24}"
        additionalLabel2.text = "2\u{20BE} = 7.12\u{24}"
        
        
        additionalLabel1.font = additionalLabel1.font.withSize(100) //Just set max and resize after
        additionalLabel1.adjustsFontSizeToFitWidth = true
        additionalLabel1.textAlignment = .right
        additionalLabel1.textColor = Theme.Color.secondText
        
        additionalLabel2.font = additionalLabel2.font.withSize(100) //Just set max and resize after
        additionalLabel2.adjustsFontSizeToFitWidth = true
        additionalLabel2.textAlignment = .right
        additionalLabel2.textColor = Theme.Color.secondText

    }
    
    private func setupGraph() {
        contentView.addSubview(graph)
        graph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            graph.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standartLayoutSpace),
            graph.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: standartLayoutSpace),
            graph.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -standartLayoutSpace),
            graph.heightAnchor.constraint(equalToConstant: standartLayoutSpace*5)
        ])
        
       // graph.backgroundColor = Theme.Color.border
        self.layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect (
//            x: graph.bounds.minX,
//            y: graph.bounds.midY,
//            width: graph.bounds.width,
//            height: graph.bounds.height/2)
        gradientLayer.frame = graph.bounds
        gradientLayer.colors = [Theme.Color.background.cgColor, Theme.Color.border.cgColor]
        graph.layer.insertSublayer(gradientLayer, at: 0)
        

        
    }
    
}

//
//  AddTileView.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import UIKit

class AddTileUIView: UIView {
    
    let image = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }
    
    private func setup() {
        backgroundColor = Theme.Color.background
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(image)
        self.addSubview(label)

        image.image = UIImage(systemName: "rectangle.badge.plus")
        image.contentMode = .scaleAspectFill
        image.tintColor = .darkGray
        
        label.text = "Add currency"
        label.font = label.font.withSize(100) //Just set max and resize after
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .darkGray
       
        
        NSLayoutConstraint.activate([

            image.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            image.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            label.heightAnchor.constraint(equalTo: image.heightAnchor, multiplier: 0.3),
            label.widthAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.5),
            label.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        
    }

}

//
//  Theme.swift
//  Currency Widget
//
//  Created by macSlm on 05.10.2023.
//

import Foundation
import UIKit


class Theme {
    static let shared = Theme()
    
    enum Color {
        static let background = UIColor(red: 240/255, green: 241/255, blue: 245/255, alpha: 1)
        static let naviBar = UIColor(red: 240/255, green: 241/255, blue: 245/255, alpha: 1)
        
        static let backgroundForWidgets = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        static let mainText = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        static let secondText = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.8)
        static let invertedText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let separator = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.2)
        
        static let border = UIColor(red: 98/255, green: 133/255, blue: 189/255, alpha: 1)
        
        //static let mainColor = UIColor(red: 117/255, green: 53/255, blue: 145/255, alpha: 1)
        static let mainColor = UIColor(red: 71/255, green: 155/255, blue: 166/255, alpha: 1)
        static let mainColorPale = mainColor.withAlphaComponent(0.15)
        
        static let green = UIColor.systemGreen
        static let red = UIColor.systemRed
        
    }
    
    enum Radius {
        static let mainWidget = UIScreen.main.bounds.height/50
        static let minimal = UIScreen.main.bounds.height/100
    }
    
    static let colorsForGradient = [
        //blue
        [UIColor(red: 43/255, green: 88/255, blue: 237/255, alpha: 1).cgColor,
         UIColor(red: 14/255, green: 29/255, blue: 79/255, alpha: 1).cgColor],
        //red
        [UIColor(red: 237/255, green: 64/255, blue: 112/255, alpha: 1).cgColor,
         UIColor(red: 79/255, green: 14/255, blue: 30/255, alpha: 1).cgColor],
        //green
        [UIColor(red: 43/255, green: 237/255, blue: 67/255, alpha: 1).cgColor,
         UIColor(red: 14/255, green: 29/255, blue: 24/255, alpha: 1).cgColor],
        //orange
        [UIColor(red: 237/255, green: 184/255, blue: 43/255, alpha: 1).cgColor,
         UIColor(red: 51/255, green: 49/255, blue: 42/255, alpha: 1).cgColor]
    ]
    
}

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
        
        static let mainColor = UIColor(red: 117/255, green: 53/255, blue: 145/255, alpha: 1)
        static let mainColorPale = UIColor(red: 117/255, green: 53/255, blue: 145/255, alpha: 0.15)
        
    }
    
    enum Radius {
        static let mainWidget = UIScreen.main.bounds.height/50
        static let minimal = UIScreen.main.bounds.height/150
    }
    
}

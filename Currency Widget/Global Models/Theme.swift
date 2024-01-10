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
        static let background = UIColor(red: 236/255, green: 237/255, blue: 243/255, alpha: 1)
        static let backgroundForWidgets = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let segmentedControlBackground = UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1)
        
        static let mainText = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        static let secondText = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        static let invertedText = UIColor(red: 236/255, green: 182/255, blue: 147/255, alpha: 1)
        static let separator = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.2)
        
        static let border = UIColor(red: 98/255, green: 133/255, blue: 189/255, alpha: 1)
        
        //static let mainColor = UIColor(red: 117/255, green: 53/255, blue: 145/255, alpha: 1)
        
        static let mainColor = UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1)
        static let mainColorPale = UIColor(red: 103/255, green: 111/255, blue: 157/255, alpha: 1)
        
        static let accentColor = UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1)

        static let green = UIColor.systemGreen
        static let red = UIColor.systemRed
        
        static let tabBarBackground = UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1)
        static let tabBarText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
      
    }
    
    enum Radius {
        static let mainWidget = UIScreen.main.bounds.height/50
        static let minimal = UIScreen.main.bounds.height/100
    }
    
    static let currencyColors = [ #colorLiteral(red: 0.9025027752, green: 0.3524039388, blue: 0.9095708728, alpha: 1), #colorLiteral(red: 0.08765161783, green: 0.244926393, blue: 0.8508421779, alpha: 1), #colorLiteral(red: 0.9009088874, green: 0.2419643998, blue: 0.1973203123, alpha: 1), #colorLiteral(red: 0.9128024578, green: 0.2714713812, blue: 0.4699001908, alpha: 1), #colorLiteral(red: 0.4715684056, green: 0.9117004275, blue: 0.4237037301, alpha: 1) ]
    
//    static let colorsForGradient = [
//        //blue 86, 127, 133
//       [UIColor(red: 86/255, green: 127/255, blue: 133/255, alpha: 1).cgColor,
//        UIColor(red: 86/255, green: 127/255, blue: 133/255, alpha: 1).cgColor],
//
//       //red 69, 45, 28
//       [UIColor(red: 69/255, green: 45/255, blue: 28/255, alpha: 1).cgColor,
//        UIColor(red: 154/255, green: 131/255, blue: 113/255, alpha: 1).cgColor],
//
//       //green 177, 194, 196
//       [UIColor(red: 177/255, green: 194/255, blue: 196/255, alpha: 1).cgColor,
//        UIColor(red: 177/255, green: 194/255, blue: 196/255, alpha: 1).cgColor],
//        
//       //orange
//        [UIColor(red: 154/255, green: 131/255, blue: 113/255, alpha: 1).cgColor,
//         UIColor(red: 154/255, green: 131/255, blue: 113/255, alpha: 1).cgColor]
//    ]
    
    
    
}

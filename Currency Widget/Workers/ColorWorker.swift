//
//  ThemeColors.swift
//  Currency Widget
//
//  Created by  slm on 25.01.2024.
//

import UIKit
import RxSwift




enum AppTheme: Codable {
    case dark
    case light
    case system
}

protocol ColorsWorkerProtocol {
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    
    func returnColors() -> AppColors
    func returnAppTheme() -> AppTheme
    func newAppTheme(newTheme: AppTheme)
}

class ColorsWorker {
    let defaults = UserDefaults.standard
    let bag = DisposeBag()
    
    var rxAppThemeUpdated = BehaviorSubject(value: false)
    var appTheme = AppTheme.system
    
    init() {
        fetchFromDefaults()
        subscribing()
    }
    
    private func subscribing() {
        rxAppThemeUpdated.subscribe{ _ in
            self.saveToDefaults()
        }.disposed(by: bag)
    }
    
}

extension ColorsWorker: ColorsWorkerProtocol {
    func returnAppTheme() -> AppTheme {
        return appTheme
    }
    
    func returnColors() -> AppColors {
        
        if appTheme == .system {
            let systemTheme = UIScreen.main.traitCollection.userInterfaceStyle
            if systemTheme == .light { return returnLight() }
            else {
                return returnDark()
            }
        }
        
        if appTheme == .light { return returnLight() }
        if appTheme == .dark  { return returnDark()  }

        return returnDark()
    }
    
    func newAppTheme(newTheme: AppTheme) {
        appTheme = newTheme
        rxAppThemeUpdated.onNext(true)
    }
    
}
    


// MARK: - USER DEFAULTS
extension ColorsWorker {
    private func saveToDefaults() {
        let encoder = JSONEncoder()
        if let theme = try? encoder.encode(appTheme){
            defaults.set(theme, forKey: "AppTheme")
            print("--App theme was saved--")
        }
    }
    
    private func fetchFromDefaults() {
        
        if let savedData = defaults.object(forKey: "AppTheme") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedTheme = try decoder.decode(AppTheme.self, from: savedData)
                print("SAVED THEME IS \(savedTheme)")
                if savedTheme != .system {
                    appTheme = savedTheme
                    rxAppThemeUpdated.onNext(true)
                }
            }
            catch { return }
        }
    }
}

 //MARK: - RETURN COLORS
extension ColorsWorker {
    private func returnLight() -> AppColors {
        return AppColors(
            background: UIColor(red: 236/255, green: 237/255, blue: 243/255, alpha: 1),
            backgroundForWidgets: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            
            segmentedControlSegment: UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1),
            segmentedControlSelectedText: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            segmentedControlSecondText: UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1),
            
            mainText: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1),
            secondText: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5),
            invertedText: UIColor(red: 236/255, green: 182/255, blue: 147/255, alpha: 1),
            separator: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.2),
            
            border: UIColor(red: 98/255, green: 133/255, blue: 189/255, alpha: 1),
            
            mainColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1),
            mainColorPale: UIColor(red: 103/255, green: 111/255, blue: 157/255, alpha: 1),
            closingLine: UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1),
            
            accentColor: UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1),
            heartColor: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1),
            clearButton: UIColor(red: 22/255, green: 30/255, blue: 49/255, alpha: 1),
            
            green: UIColor.systemGreen,
            red: UIColor.systemRed,
            
            tabBarBackground: UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1),
            tabBarText: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            tabBarLine: UIColor(red: 51/255, green: 57/255, blue: 95/255, alpha: 1),
            currencyColors: [ #colorLiteral(red: 0.9025027752, green: 0.3524039388, blue: 0.9095708728, alpha: 1), #colorLiteral(red: 0.08765161783, green: 0.244926393, blue: 0.8508421779, alpha: 1), #colorLiteral(red: 0.9009088874, green: 0.2419643998, blue: 0.1973203123, alpha: 1), #colorLiteral(red: 0.9128024578, green: 0.2714713812, blue: 0.4699001908, alpha: 1), #colorLiteral(red: 0.4715684056, green: 0.9117004275, blue: 0.4237037301, alpha: 1) ]
        )
    }
    
    private func returnDark() -> AppColors {
        return AppColors(
            background: #colorLiteral(red: 0.08627282828, green: 0.1164394692, blue: 0.1934950352, alpha: 1),
            backgroundForWidgets: #colorLiteral(red: 0.1747960448, green: 0.1961129904, blue: 0.3142392039, alpha: 1),
            
            segmentedControlSegment: #colorLiteral(red: 0.08627282828, green: 0.1164394692, blue: 0.1934950352, alpha: 1),
            segmentedControlSelectedText: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            segmentedControlSecondText: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            
            mainText: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            secondText: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5),
            invertedText: UIColor(red: 236/255, green: 182/255, blue: 147/255, alpha: 1),
            separator: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2),
            
            border: #colorLiteral(red: 0.2479126155, green: 0.2621334791, blue: 0.3463309109, alpha: 1),
            
            mainColor: #colorLiteral(red: 0.08627282828, green: 0.1164394692, blue: 0.1934950352, alpha: 1),
            mainColorPale: #colorLiteral(red: 0.08627282828, green: 0.1164394692, blue: 0.1934950352, alpha: 0.5),
            closingLine: UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1),
            
            accentColor: UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1),
            heartColor: UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1),
            clearButton: UIColor(red: 252/255, green: 174/255, blue: 113/255, alpha: 1),

            green: UIColor.systemGreen,
            red: UIColor.systemRed,
            
            tabBarBackground: #colorLiteral(red: 0.08627282828, green: 0.1164394692, blue: 0.1934950352, alpha: 1),
            tabBarText: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
            tabBarLine: #colorLiteral(red: 0.2479126155, green: 0.2621334791, blue: 0.3463309109, alpha: 1),
            currencyColors: [ #colorLiteral(red: 0.9025027752, green: 0.3524039388, blue: 0.9095708728, alpha: 1), #colorLiteral(red: 0.08765161783, green: 0.244926393, blue: 0.8508421779, alpha: 1), #colorLiteral(red: 0.9009088874, green: 0.2419643998, blue: 0.1973203123, alpha: 1), #colorLiteral(red: 0.9128024578, green: 0.2714713812, blue: 0.4699001908, alpha: 1), #colorLiteral(red: 0.4715684056, green: 0.9117004275, blue: 0.4237037301, alpha: 1) ]
        )
    }
}


//
//  SettingsList.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation



enum PropertyType: String, Codable {
    case baseCurrency = "Base currency"
    case actualTo = "Actual to"
}

protocol SettingsProtocol {
    func getSettings() -> [PropertyType: String]
    func getProperty(key: PropertyType) -> String
    func changeProperty(key: PropertyType, newValue: String)
}

class SettingsWorker: SettingsProtocol {
    let defaults = UserDefaults.standard
    
    var settingsList: [PropertyType: String] = [:]
    
    init() {
        settingsList=fetchFromDefaults()
    }
    
    func changeProperty(key: PropertyType, newValue: String) {
        settingsList.updateValue(newValue, forKey: key)
    }
    
    func getSettings() -> [PropertyType: String] {
        return settingsList
    }
    func getProperty(key: PropertyType) -> String {
        return settingsList[key] ?? "Property is wrong"
    }
  
}


// MARK: - USER DEFAULTS
extension SettingsWorker {
    private func saveToDefaults() {
        let encoder = JSONEncoder()
        
        if let settings = try? encoder.encode(settingsList) {
            defaults.set(settings, forKey: "SettingsList")
            print("--Settings was saved--")
        }
    }
    
    private func fetchFromDefaults() -> [PropertyType: String] {
        var list: [PropertyType: String] = [
            PropertyType.baseCurrency: "USD",
            PropertyType.actualTo: "Date Error"
        ]
        
        if let savedData = defaults.object(forKey: "SettingsList") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedList = try decoder.decode([PropertyType: String].self, from: savedData)
                list = savedList
            }
            catch {
                return list
            }
        }
        return list
    }
}




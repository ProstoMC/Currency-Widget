//
//  SettingsList.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation

struct Property {
    var type: PropertyType
    var value: String
}

enum PropertyType: String {
    case baseCurrency = "Base currency"
}

protocol SettingsProtocol {
    //var settingsList: [Property] { get }
    func getSettings() -> [Property]
    func changeBaseCurrency(newBaseShortName: String)
}

class SettingsWorker: SettingsProtocol {
    var settingsList: [Property] = []
    
    init() {
        fetchSettingsFromDefaults()
    }
    
    func changeBaseCurrency(newBaseShortName: String) {
        if settingsList[0].type == .baseCurrency { // For being sure
            settingsList[0].value = newBaseShortName
        }
    }
    
    func getSettings() -> [Property] {
        return settingsList
    }
  
}

extension SettingsWorker {
    private func fetchSettingsFromDefaults() {
        settingsList.append(Property(type: .baseCurrency, value: "RUB"))
    }
}



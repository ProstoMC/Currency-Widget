//
//  UserDefaultsWorker.swift
//  Currency Widget
//
//  Created by macSlm on 18.12.2023.
//

import Foundation

protocol UserDefaultsWorkerProtocol {
    func saveCurrencyListToDefaults(currencyList: CurrencyListForDefaults)
    func getCurrencyListFromDefaults() -> CurrencyListForDefaults
    
    func savePairsToDefaults(pairListForDefaults: PairListForDefaults)
    func getPairsFromDefaults() -> PairListForDefaults
}

class UserDefaultsWorker: UserDefaultsWorkerProtocol {
    
    let defaults = UserDefaults.standard
    
    // MARK:  - CURRENCY LIST
    func saveCurrencyListToDefaults(currencyList: CurrencyListForDefaults) {
        let encoder = JSONEncoder()

        if let encodedList = try? encoder.encode(currencyList) {
            defaults.set(encodedList, forKey: "currencyList")
        }
        print("--Values from eth saved--")
    }
    
    func getCurrencyListFromDefaults() -> CurrencyListForDefaults {
        var list = CurrencyListForDefaults(lastUpdate: "Error", currencyValues: [])
        
        if let savedData = defaults.object(forKey: "currencyList") as? Data {
            let decoder = JSONDecoder()
            do {
                let savedList = try decoder.decode(CurrencyListForDefaults.self, from: savedData)
                list = savedList
            }
            catch { list = CurrencyListForDefaults(lastUpdate: "Error decoding", currencyValues: []) }
        }
        return list
    }
}

// MARK:  - PAIRS
extension UserDefaultsWorker {
    func savePairsToDefaults(pairListForDefaults: PairListForDefaults) {
        let encoder = JSONEncoder()
        
        if let encodedList = try? encoder.encode(pairListForDefaults) {
            defaults.set(encodedList, forKey: "pairList")
            //print("SAVING")
        }
    }
    
    func getPairsFromDefaults() -> PairListForDefaults {
        var list = PairListForDefaults(pairs: [])
        
        if let savedData = defaults.object(forKey: "pairList") as? Data {
            let decoder = JSONDecoder()
            if let savedList = try? decoder.decode(PairListForDefaults.self, from: savedData) {
                list = savedList
            }
        }
        return list
    }
}

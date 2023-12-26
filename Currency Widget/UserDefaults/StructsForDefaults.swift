//
//  CurrencyValues.swift
//  Currency Widget
//
//  Created by macSlm on 18.12.2023.
//

import Foundation


// MARK:  - Currency
struct CurrencyValuesForDefaults: Encodable, Decodable {
    
    var shortName: String
    var rate: Double
    var previousRate: Double
    var base: String
    
    var colorIndex: Int
}

struct CurrencyListForDefaults: Encodable, Decodable {
    var lastUpdate: String
    var currencyValues: [CurrencyValuesForDefaults]
}

// MARK:  - Pairs
struct PairForDefaults: Encodable, Decodable {
    var valueName: String
    var baseName: String
    var position: Int
}


struct PairListForDefaults: Encodable, Decodable {
    var pairs: [PairForDefaults]
}

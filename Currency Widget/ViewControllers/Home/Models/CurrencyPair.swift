//
//  CurrencyPair.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation

struct CurrencyPair {
    var position: Int
    var valueCurrencyShortName: String
    var valueCurrencyLogo: String
    var baseCurrencyShortName: String
    var value: String
    var baseLogo: String

    init(valueCurrency: Currency, baseCurrency: Currency, position: Int) {
        self.position = position
        self.valueCurrencyShortName = valueCurrency.shortName
        self.valueCurrencyLogo = valueCurrency.logo
        self.baseCurrencyShortName = baseCurrency.shortName
        
        let valueDouble = valueCurrency.rate / baseCurrency.rate
        self.value = String(Double(round(100 * valueDouble) / 100)) //Making 2 symbols after dot
        
        self.baseLogo = baseCurrency.logo
    }
}

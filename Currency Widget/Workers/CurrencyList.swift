//
//  CurrencyList.swift
//  Currency Widget
//
//  Created by macSlm on 21.11.2023.
//

import Foundation
import RxSwift

protocol CurrencyListProtocol {
    func getBaseCurrency() -> Currency
    func getlistCount() -> Int
    func getFullList() -> [Currency]
    func getCurrency(name: String) -> Currency
    
    func setBaseCurrency(name: String)
    func setCurrencyValue(name: String, value: Double, previousValue: Double, colorIndex: Int?) // Color Index not used if it nil
    
}


class CurrencyList: CurrencyListProtocol {
    
    private var base: Currency
    private var list: [Currency]
    
    init() {
        base = Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "RUB")
        
        list = [
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "RUB"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "AUD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "AZN"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "GBP"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "AMD"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "BYN"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "BGN"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "BRL"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "HUF"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "VND"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "HKD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "GEL"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "DKK"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "AED"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "USD"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "EUR"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "EGP"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "INR"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "IDR"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "KZT"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "CAD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "QAR"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "KGS"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "CNY"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "MDL"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "NZD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "NOK"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "PLN"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "RON"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "XDR"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "SGD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "TJS"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "THB"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "TRY"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "TMT"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "UZS"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "UAH"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "CZK"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "SEK"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "CHF"),
            
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "RSD"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "ZAR"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "KRW"),
            Currency(rate: 1, previousRate: 1, base: "RUB", shortName: "JPY"),
            
        ]
        
        setColor()
    }
    private func setColor() {
        var index = 0
        list.indices.forEach {
            list[$0].colorIndex = index
            index = index + 1
            if index > Theme.currencyColors.count-1 {
                index = 0
            }
        }
    }
    
}

// MARK:  - GETTING

extension CurrencyList {

    func getBaseCurrency() -> Currency {
        return base
    }
    func getlistCount() -> Int {
        return list.count
    }
    
    func getFullList() -> [Currency] {
        return list
    }
    
    func getCurrency(name: String) -> Currency {
        var currency = Currency(rate: 0, previousRate: 0, base: "ERR", shortName: "ERR")
        for element in list {
            if element.shortName == name {
                currency = element
                break
            }
        }
        return currency
    }
    
    func printList() {
        for currency in list {
            do {
                let value = try currency.rateRx.value()
                print("\(currency.shortName) = \(value)")
            } catch {
                print("\(currency.shortName) has no value")
            }
            
        }
    }

}

// MARK:  - SETTING

extension CurrencyList {
    
    func setBaseCurrency(name: String) {
        do {
            let ratio = try getCurrency(name: name).rateRx.value()
            base = Currency(rate: 1, previousRate: 1, base: name, shortName: name)
            
            for i in list.indices {
                
                list[i].base = name
                let oldRate = try list[i].rateRx.value()
                let oldPrevious = try list[i].previousRateRx.value()
                list[i].rateRx.onNext(oldRate/ratio)
                list[i].previousRateRx.onNext(oldPrevious/ratio)
            }
            
        } catch {
            return
        }
    }
    
    func setCurrencyValue(name: String, value: Double, previousValue: Double, colorIndex: Int?) {
        list.indices.forEach {
            if list[$0].shortName == name {
                list[$0].rateRx.on(.next(value))
                list[$0].previousRateRx.on(.next(previousValue))
                list[$0].flowRateRx.on(.next(value-previousValue))
                if colorIndex != nil {
                    list[$0].colorIndex = colorIndex!
                }
            }
        }
        
    }

}

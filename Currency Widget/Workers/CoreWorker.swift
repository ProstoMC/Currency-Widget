//
//  CoreWorker.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.
//

import Foundation
import RxSwift

class CoreWorker {
    static let shared = CoreWorker()
    
    let currencyFetcher = CurrencyFetcher()
    let currencyList: CurrencyListProtocol = CurrencyList()
    
    public var favoritePairList: [CurrencyPair] = []
    public let rxFavouritPairsCount = BehaviorSubject<Int>(value: 0)
    
    public let rxExchangeFromCurrency = BehaviorSubject<String>(value: "RUB")
    public let rxExchangeToCurrency = BehaviorSubject<String>(value: "USD")
    
    init() {
        getFavoritePairs()
        updateRates()

    }
    
}



// MARK:  - INIT
extension CoreWorker {
    private func getFavoritePairs() {
        favoritePairList = [
            CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: "GEL"),
                baseCurrency: currencyList.getBaseCurrency(),
                position: 0),
            CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: "USD"),
                baseCurrency: currencyList.getBaseCurrency(),
                position: 1),
            CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: "AMD"),
                baseCurrency: currencyList.getBaseCurrency(),
                position: 2),
            CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: "USD"),
                baseCurrency: currencyList.getCurrency(name: "GEL"),
                position: 3)
        ]
        rxFavouritPairsCount.onNext(favoritePairList.count)
    }
    
    private func updateRates() {
        currencyFetcher.fetchCurrencyDaily(completion: { valuteList in
            self.currencyList.setBaseCurrency(name: "RUB")
            
            for currency in valuteList {
                
                let charCode = currency.value.CharCode
                let value = currency.value.Value / currency.value.Nominal
                let previousValue = currency.value.Previous / currency.value.Nominal
                //let name = currency.value.Name  //It is russian name
                
                self.currencyList.setCurrencyValue(name: charCode, value: value, previousValue: previousValue)
            }
        })
    }
}

// MARK:  - Currency Pair Module
extension CoreWorker {
    func addPairToFavoriteList(pair: CurrencyPair){
        favoritePairList.append(pair)
        rxFavouritPairsCount.onNext(favoritePairList.count) //Push for updating view
    }
}
// MARK:  - Exchange Module
extension CoreWorker {
    func setFromCurrencyExchange(name: String){
        rxExchangeFromCurrency.onNext(name)
    }
    func setToCurrencyExchange(name: String) {
        rxExchangeToCurrency.onNext(name)
    }
    
    func switchExchangeFields() {
        print("switchFields")
        do {
            let newFromName = try rxExchangeToCurrency.value()
            rxExchangeToCurrency.onNext(try rxExchangeFromCurrency.value())
            rxExchangeFromCurrency.onNext(newFromName)
        }catch {
            return
        }
    }
}

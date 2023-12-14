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
    
    public var favoritePairList: [CurrencyPair] = []
    public let rxFavouritPairsCount = BehaviorSubject<Int>(value: 0)
    
    public let rxExchangeFromCurrency = BehaviorSubject<String>(value: "RUB")
    public let rxExchangeToCurrency = BehaviorSubject<String>(value: "USD")
    
    init() {
        getFavoritePairs()
        CurrencyFetcher.shared.fetchCurrencyDaily(completion: {
            
        })
    }
    
}



// MARK:  - INIT
extension CoreWorker {
    private func getFavoritePairs() {
        favoritePairList = [
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "GEL"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 0),
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "USD"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 1),
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "AMD"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 2),
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "USD"),
                baseCurrency: CurrencyList.shared.getCurrency(name: "GEL"),
                position: 3)
        ]
        rxFavouritPairsCount.onNext(favoritePairList.count)
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

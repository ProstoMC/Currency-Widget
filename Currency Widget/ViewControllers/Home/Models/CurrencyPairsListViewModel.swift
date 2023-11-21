//
//  ViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol CurrencyPairsListViewModelProtocol {
    var pairList: Observable<CurrencyPair> { get }
    var pairs: [CurrencyPair] { get }
}

class CurrencyPairsListViewModel: CurrencyPairsListViewModelProtocol {
    var pairs: [CurrencyPair] = []
    
    
    var pairList: RxSwift.Observable<CurrencyPair>
    
    init() {
        if CurrencyList.shared.getlistCount() > 2 {
            pairs = [
                CurrencyPair(
                    valueCurrency: CurrencyList.shared.getCurrency(name: "GEL"),
                    baseCurrency: CurrencyList.shared.getBaseCurrency(),
                    position: 0)
        //        CurrencyPair(valueCurrency: "GEL", baseCurrency: "RUB", position: 1),
        //        CurrencyPair(valueCurrency: "USD", baseCurrency: "GEL", position: 1)
            ]
            print (pairs.count)
        
        }
        pairList = Observable.from(pairs)
    }
 
}

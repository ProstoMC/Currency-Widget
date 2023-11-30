//
//  ViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol CurrencyPairsListViewModelProtocol {
    var pairList: BehaviorRelay<[SectionOfCustomData]> { get }
    
    func addCell()
    //var pairs: [CurrencyPair] { get }
}

class CurrencyPairsListViewModel: CurrencyPairsListViewModelProtocol {
    var pairList: BehaviorRelay<[SectionOfCustomData]>
    var pairs: [CurrencyPair] = []
    var section: SectionOfCustomData!
    
    init() {
        
        pairs = [
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "GEL"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 0),
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "USD"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 1),
            CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "USD"),
                baseCurrency: CurrencyList.shared.getCurrency(name: "GEL"),
                position: 2)
        ]
        
        section = SectionOfCustomData(header: "Header", items: pairs)
        
        pairList = BehaviorRelay(value: [section])
     
    }
    
    func addCell() {
        pairs.append(CurrencyPair(valueCurrency: CurrencyList.shared.getCurrency(name: "EUR"),
                                          baseCurrency: CurrencyList.shared.getBaseCurrency(), position: 3))
        section = SectionOfCustomData(header: "Header", items: pairs)
        pairList.accept([section])
    }
    
    
}

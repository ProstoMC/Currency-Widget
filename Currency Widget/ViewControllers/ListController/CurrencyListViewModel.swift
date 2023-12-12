//
//  CurrencyListModel.swift
//  Currency Widget
//
//  Created by macSlm on 04.12.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol CurrencyListViewModelProtocol {
    var rxFiatList: BehaviorRelay<[SectionOfCurrencyList]> { get }
    //var rxCoinList: BehaviorRelay<[SectionOfCurrencyList]> { get }
    
    //var pairs: [CurrencyPair] { get }
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    
    var rxFiatList: BehaviorRelay<[SectionOfCurrencyList]>
    //var rxCoinList: BehaviorRelay<[SectionOfCurrencyList]>
    
    var fiatList: [Currency]
    
    init() {
        //making empty array
        fiatList = []
        var section = SectionOfCurrencyList(header: "Header", items: fiatList)
        rxFiatList = BehaviorRelay(value: [section]) //we have to define it before
        
        //filling array
        fiatList = getCurrencyList()
        section = SectionOfCurrencyList(header: "Header", items: fiatList)
        rxFiatList.accept([section])
    }
    
}

extension CurrencyListViewModel {
    private func getCurrencyList() -> [Currency]{
        var list = CurrencyList.shared.getFullList()
        //removing base Currency from list
        list.enumerated().forEach { (index, item) in
            if item.shortName == CurrencyList.shared.getBaseCurrency().shortName {
                list.remove(at: index)
            }
        }
        return list
    }
}

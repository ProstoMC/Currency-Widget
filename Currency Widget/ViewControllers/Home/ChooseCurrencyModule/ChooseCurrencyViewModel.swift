//
//  ChooseCurrencyViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol ChooseCurrencyViewModelProtocol {
    var rxFiatList: BehaviorRelay<[SectionOfCurrencyList]> { get }
    //var rxCoinList: BehaviorRelay<[SectionOfCurrencyList]> { get }
    
    //var pairs: [CurrencyPair] { get }
}

class ChooseCurrencyViewModel: ChooseCurrencyViewModelProtocol {
    
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

extension ChooseCurrencyViewModel {
    private func getCurrencyList() -> [Currency]{
        return CurrencyList.shared.getFullList()
    }
}

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
    
    func selectTail(currency: Currency)
    
    func findCurrency(str: String)
    func resetModel()
}

class CurrencyListViewModel: CurrencyListViewModelProtocol {
    
    var rxFiatList: BehaviorRelay<[SectionOfCurrencyList]>
    //var rxCoinList: BehaviorRelay<[SectionOfCurrencyList]>
    
    var fiatList: [Currency] = []
    
    init() {
        //making empty array
        var section = SectionOfCurrencyList(header: "Header", items: fiatList)
        rxFiatList = BehaviorRelay(value: [section]) //we have to define it before
        
        //filling array
        fiatList = getCurrencyList()
        section = SectionOfCurrencyList(header: "Header", items: fiatList)
        rxFiatList.accept([section])
    }
    
    func selectTail(currency: Currency) {
        CoreWorker.shared.setFromCurrencyExchange(name: currency.shortName)
        CoreWorker.shared.setToCurrencyExchange(name: currency.base)
    }
    
    func findCurrency(str: String) {
        var foundedList: [Currency] = []

        let list = getCurrencyList()
        
        if str == "" {
            foundedList = list
        } else {
            //Delete each elements not contained
            for item in list {
                if item.name.uppercased().contains(str.uppercased()) ||
                    item.shortName.uppercased().contains(str.uppercased()) {
                    foundedList.append(item)
                }
            }
        }
        //Make new table
        let section = SectionOfCurrencyList(header: "Header", items: foundedList)
        rxFiatList.accept([section])
    }
    
    func resetModel() {
        fiatList = getCurrencyList()
        let section = SectionOfCurrencyList(header: "Header", items: fiatList)
        rxFiatList.accept([section])
    }
    
    
}

extension CurrencyListViewModel {
    private func getCurrencyList() -> [Currency]{
        var list = CoreWorker.shared.currencyList.getFullList()
        //removing base Currency from list
        list.enumerated().forEach { (index, item) in
            if item.shortName == CoreWorker.shared.currencyList.getBaseCurrency().shortName {
                list.remove(at: index)
            }
        }
        return list
    }
    
    
    
}

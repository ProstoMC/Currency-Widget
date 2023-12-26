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
    var type: String { set get }
    
    var rxFiatList: BehaviorRelay<[SectionOfCurrencyList]> { get }
    
    func setCurrency(shortName: String)
    func findCurrency(str: String)
}

class ChooseCurrencyViewModel: ChooseCurrencyViewModelProtocol {
    
    var type = "Error" //Set default. values: from, to
    
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
    
    func setCurrency(shortName: String) {
        if type == "from" {
            CoreWorker.shared.setFromCurrencyExchange(name: shortName)
        }
        if type == "to" {
            CoreWorker.shared.setToCurrencyExchange(name: shortName)
        }
        
    }
    
    func findCurrency(str: String) {
        
        guard str != "" else { return }
        
        let list = getCurrencyList()
        var foundedList: [Currency] = []
        //Delete each elements not contained
        for item in list {
            if item.name.uppercased().contains(str.uppercased()) ||
                item.shortName.uppercased().contains(str.uppercased()) {
                foundedList.append(item)
            }
        }
        //Make new table
        let section = SectionOfCurrencyList(header: "Header", items: foundedList)
        rxFiatList.accept([section])
    }
    
}

extension ChooseCurrencyViewModel {
    private func getCurrencyList() -> [Currency]{
        return CoreWorker.shared.currencyList.getFullList()
    }
}

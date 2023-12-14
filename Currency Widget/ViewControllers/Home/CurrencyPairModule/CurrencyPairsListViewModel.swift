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
    var rxPairList: BehaviorRelay<[SectionOfCustomData]> { get }
    
    func addCell()
    func selectTail(pair: CurrencyPair)
    
}

class CurrencyPairsListViewModel: CurrencyPairsListViewModelProtocol {
    var rxPairList: BehaviorRelay<[SectionOfCustomData]>
    var section: SectionOfCustomData!
    let bag = DisposeBag()
    
    init() {
        //Start with nulls
        section = SectionOfCustomData(header: "Header", items: [])
        rxPairList = BehaviorRelay(value: [self.section])
        
        subscribeToCoreWorker()
    }
    
    func subscribeToCoreWorker(){
        
        //Update view after pairsList was updated
        CoreWorker.shared.rxFavouritPairsCount.subscribe({ count in  //I dont need count
            
            self.section = SectionOfCustomData(header: "Header", items: CoreWorker.shared.favoritePairList)
            self.rxPairList.accept([self.section])
        }).disposed(by: bag)
    }
    
// MARK: - Funcions

    func addCell() {
        CoreWorker.shared.addPairToFavoriteList(pair: CurrencyPair(
                valueCurrency: CurrencyList.shared.getCurrency(name: "EUR"),
                baseCurrency: CurrencyList.shared.getBaseCurrency(),
                position: 3))
    }
    
    func selectTail(pair: CurrencyPair) {
        CoreWorker.shared.setFromCurrencyExchange(name: pair.valueCurrencyShortName)
        CoreWorker.shared.setToCurrencyExchange(name: pair.baseCurrencyShortName)
    }
    
    
}

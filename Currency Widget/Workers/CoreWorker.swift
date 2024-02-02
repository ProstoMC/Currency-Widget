//
//  CoreWorker.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.



//  Main worker, core of app

//  Launched from TabBar View Controller

import Foundation
import RxSwift

class CoreWorker {
    
    static let shared = CoreWorker()
    
    let bag = DisposeBag()
    
    //Colors
    let colorsWorker: ColorsWorkerProtocol = ColorsWorker()
    
    //Currency List
    let coinList: CoinListProtocol = UniversalCoinWorker()
    
    //Favourite pairs
    let favouritePairList: CoinPairProtocol = CoinPairWorker()
    
    //Exchange
    let exchangeWorker: ExchangeWorkerProtocol = ExchangeWorker()
    
    
    init() {
        updateExchangeFields()
    }
    
    private func updateExchangeFields(){
        favouritePairList.rxPairListCount.subscribe { count in
            //We do not need update it if we have rows filled
            if self.exchangeWorker.fromCoin != "" && self.exchangeWorker.toCoin != "" {
                return
            }
            //Make default if we do not have favourite pairs
            if count < 1 {
            self.exchangeWorker.setFromCoin(code: "USD")
            self.exchangeWorker.setToCoin(code: "RUB")
            
            
                self.exchangeWorker.rxExchangeFlag.onNext(false) // Do not open details
                return
            }
            
            self.exchangeWorker.setFromCoin(code: self.favouritePairList.pairList[0].valueCode)
            self.exchangeWorker.setToCoin(code: self.favouritePairList.pairList[0].baseCode)
            self.exchangeWorker.rxExchangeFlag.onNext(false) // Do not open details
            
        }.disposed(by: bag)
    }
    
    
    
}

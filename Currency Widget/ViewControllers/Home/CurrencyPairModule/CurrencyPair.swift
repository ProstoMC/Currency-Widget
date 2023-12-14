//
//  CurrencyPair.swift
//  Currency Widget
//
//  Created by macSlm on 31.10.2023.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import Differentiator

struct CurrencyPair {
    var position: Int
    var valueCurrencyShortName: String
    var valueCurrencyLogo: String
    var baseCurrencyShortName: String
    var baseLogo: String
    var colorIndex: Int
    
    var rxValue = BehaviorSubject<Double>(value: 0)
    var rxValueFlow = BehaviorSubject<Double>(value: 0)
    let disposeBag = DisposeBag()

    init(valueCurrency: Currency, baseCurrency: Currency, position: Int) {
        self.position = position
        self.valueCurrencyShortName = valueCurrency.shortName
        self.valueCurrencyLogo = valueCurrency.logo
        self.baseCurrencyShortName = baseCurrency.shortName
        self.baseLogo = baseCurrency.logo
        self.colorIndex = valueCurrency.colorIndex
        
        // MARK:  - RX Components
        
        //RxValue
        Observable.combineLatest(valueCurrency.rateRx, baseCurrency.rateRx){ rate, base in
            let valueDouble = rate / base
            return valueDouble
        }.subscribe(self.rxValue).disposed(by: disposeBag)
        
        //RxValueFlow
        Observable.combineLatest(rxValue, valueCurrency.previousRateRx, baseCurrency.previousRateRx){ rate, previous, basePreviouse in
            let value = rate - (previous / basePreviouse)
            
            return value
        }.subscribe(self.rxValueFlow).disposed(by: disposeBag)
    }
}





//
//  CurrencyListViewModelV2.swift
//  Currency Widget
//
//  Created by macSlm on 11.01.2024.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct CurrencyCellViewModel {
    let type: TypeOfCoin
    
    let code: String
    let name: String
    let logo: String
    
    let baseCode: String
    let baseLogo: String
    let rate: Double
    let flow: Double
    
    let imageUrl: String?
    let colorIndex: Int
    
}

struct TableSectionOfCoinUniversal {
    var header: String
    var items: [Item]
}

extension TableSectionOfCoinUniversal: SectionModelType {
    typealias Item = CurrencyCellViewModel
    
    init(original: TableSectionOfCoinUniversal, items: [Item]) {
        self = original
        self.items = items
    }
}

class CurrencyListViewModelV2: CurrencyListViewModelProtocol {
    
    
    let bag = DisposeBag()

    var rxUpdateRatesFlag = BehaviorSubject(value: false)
    var rxCoinList = BehaviorRelay(value: [TableSectionOfCoinUniversal(header: "", items: [])])
    var typeOfCoin: TypeOfCoin = .fiat
    
    init() {
        
        let list = createCoinList(type: typeOfCoin) //Always start with fiat
        let section = TableSectionOfCoinUniversal(header: "Header", items: list)
        rxCoinList.accept([section])
        
        subscribing()
    }
    

    
    func selectTail(currency: Currency) {
        CoreWorker.shared.setFromCurrencyExchange(name: currency.shortName)
        CoreWorker.shared.setToCurrencyExchange(name: currency.base)
    }
    
    func selectTail(coin: CoinUniversal) {
        return
    }
    
    func findCurrency(str: String) {
        var foundedList: [Currency] = []

//        let list = getCurrencyList()
//
//        if str == "" {
//            foundedList = list
//        } else {
//            //Delete each elements not contained
//            for item in list {
//                if item.name.uppercased().contains(str.uppercased()) ||
//                    item.shortName.uppercased().contains(str.uppercased()) {
//                    foundedList.append(item)
//                }
//            }
        }
//        //Make new table
//        let section = SectionOfCurrencyList(header: "Header", items: foundedList)
//        rxFiatList.accept([section])
//    }
//
//    func resetModel() {
//        fiatList = getCurrencyList()
//        let section = SectionOfCurrencyList(header: "Header", items: fiatList)
//        rxFiatList.accept([section])
//    }
    
    func resetModel() {
        let list = createCoinList(type: typeOfCoin)
        let section = TableSectionOfCoinUniversal(header: "Header", items: list)
        rxCoinList.accept([section])
    }
    
    
}

extension CurrencyListViewModelV2 {

    private func subscribing(){
        CoreWorker.shared.rxCoinsRateUpdated.subscribe{ status in
            let list = self.createCoinList(type: self.typeOfCoin)
            let section = TableSectionOfCoinUniversal(header: "Header", items: list)
            self.rxCoinList.accept([section])
        }.disposed(by: bag)
    }
    
    private func createCoinList(type: TypeOfCoin) -> [CurrencyCellViewModel] {
        let baseCoin = CoreWorker.shared.coinList.baseCoin
        var universalCoinList: [CoinUniversal] = []
        if type == .fiat {
            universalCoinList = CoreWorker.shared.coinList.fiatList
        }
        if type == .crypto {
            universalCoinList = CoreWorker.shared.coinList.cryptoList
        }
        
        var list: [CurrencyCellViewModel] = []
        for coin in universalCoinList {
            list.append(CurrencyCellViewModel(
                type: coin.type,
                code: coin.code,
                name: coin.name,
                logo: coin.logo,
                baseCode: baseCoin.code,
                baseLogo: baseCoin.logo,
                rate: coin.rate,
                flow: coin.flow24Hours,
                imageUrl: coin.imageUrl,
                colorIndex: coin.colorIndex))
        }
        return list
    }
    
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

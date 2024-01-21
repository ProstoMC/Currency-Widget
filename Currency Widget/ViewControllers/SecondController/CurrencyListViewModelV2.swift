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
    var rate: Double
    var flow: Double
    
    let imageUrl: String?
    var colorIndex: Int
    
    var isFavorite: Bool
    
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
    
    func selectTail(coin: CurrencyCellViewModel) {
        CoreWorker.shared.exchangeWorker.setFromCoin(code: coin.code)
        CoreWorker.shared.exchangeWorker.setToCoin(code: coin.baseCode)
    }
    
    func findCurrency(str: String) {
        var foundedList: [CurrencyCellViewModel] = []

        if str == "" {
            foundedList = createCoinList(type: typeOfCoin)
        } else {
            //Create Full list of coins
            let list = createCoinList(type: .fiat) + createCoinList(type: .crypto)
            //Delete each elements not contained
            for item in list {
                if item.code.uppercased().contains(str.uppercased()) ||
                    item.name.uppercased().contains(str.uppercased()) {
                    foundedList.append(item)
                }
            }
        }
        //Make new table
        let section = TableSectionOfCoinUniversal(header: "Header", items: foundedList)
        rxCoinList.accept([section])
    }
    
    func resetModel() {
        let list = createCoinList(type: typeOfCoin)
        let section = TableSectionOfCoinUniversal(header: "Header", items: list)
        rxCoinList.accept([section])
    }
    
}

extension CurrencyListViewModelV2 {

    private func subscribing(){
        CoreWorker.shared.coinList.rxRateUpdated.subscribe{ status in
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
            
            //CheckIsExist
            let isFavorite = CoreWorker.shared.favouritePairList.checkIsExist(valueCode: coin.code, baseCode: coin.base)
            
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
                colorIndex: coin.colorIndex,
                isFavorite: isFavorite
            ))
        }
        return list
    }

}

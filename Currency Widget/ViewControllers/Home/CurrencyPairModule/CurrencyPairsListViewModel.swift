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
    
    func selectTail(pair: CurrencyPairCellModel)
    func selectTail(indexPath: IndexPath)
    func reorderPair(fromIndex: Int, toIndex: Int)
    func deletePair(index: Int)
    
}

class CurrencyPairsListViewModel {

    
    
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
        CoreWorker.shared.favouritePairList.rxPairListCount.subscribe{ _ in  //I dont need count
            self.section = SectionOfCustomData(header: "Header", items: self.createList())
            self.rxPairList.accept([self.section])
        }.disposed(by: bag)
        
        CoreWorker.shared.coinList.rxRateUpdated.subscribe { _ in
            self.section = SectionOfCustomData(header: "Header", items: self.createList())
            self.rxPairList.accept([self.section])
        }
        .disposed(by: bag)
        
    }
    
    func createList() -> [CurrencyPairCellModel] {
        var list: [CurrencyPairCellModel] = []
        
        for pair in CoreWorker.shared.favouritePairList.pairList {
            guard let valueCurrency = CoreWorker.shared.coinList.returnCoin(code: pair.valueCode) else { continue }
            guard let baseCurrency = CoreWorker.shared.coinList.returnCoin(code: pair.baseCode) else { continue }
            
            list.append(CurrencyPairCellModel(
                valueCurrency: valueCurrency,
                baseCurrency: baseCurrency,
                colorIndex: pair.colorIndex)
            )
        }
        return list
        
    }
}


// MARK: - Protocol Funcions
extension CurrencyPairsListViewModel: CurrencyPairsListViewModelProtocol {

    func selectTail(pair: CurrencyPairCellModel) {
        CoreWorker.shared.exchangeWorker.setFromCoin(code: pair.valueCurrencyShortName)
        CoreWorker.shared.exchangeWorker.setToCoin(code: pair.baseCurrencyShortName)
    }
    func selectTail(indexPath: IndexPath){
        let pair = CoreWorker.shared.favouritePairList.pairList[indexPath.row]
        CoreWorker.shared.exchangeWorker.setFromCoin(code: pair.valueCode)
        CoreWorker.shared.exchangeWorker.setToCoin(code: pair.baseCode)
    }
    
    func reorderPair(fromIndex: Int, toIndex: Int) {
        CoreWorker.shared.favouritePairList.reorderPair(from: fromIndex, to: toIndex)
    }
    
    func deletePair(index: Int) {
        CoreWorker.shared.favouritePairList.deletePair(index: index)
    }
    
}

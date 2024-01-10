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
    
    func selectTail(pair: CurrencyPair)
    func selectTail(indexPath: IndexPath)
    func reorderPair(fromIndex: Int, toIndex: Int)
    func deletePair(index: Int)
    
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
        CoreWorker.shared.rxFavouritPairsCount.subscribe({ _ in  //I dont need count
            self.section = SectionOfCustomData(header: "Header", items: CoreWorker.shared.favoritePairList)
            self.rxPairList.accept([self.section])
            for pair in CoreWorker.shared.favoritePairList {
                print(pair.valueCurrencyShortName)
            }
            //self.changeSelectedCell()
        }).disposed(by: bag)

    }
    
// MARK: - Protocol Funcions
    func selectTail(pair: CurrencyPair) {
        CoreWorker.shared.setFromCurrencyExchange(name: pair.valueCurrencyShortName)
        CoreWorker.shared.setToCurrencyExchange(name: pair.baseCurrencyShortName)
    }
    func selectTail(indexPath: IndexPath){
        let pair = CoreWorker.shared.favoritePairList[indexPath.row]
        print("SELECTED INDEX - \(pair.position)")
        selectTail(pair: pair)
    }
    
    func reorderPair(fromIndex: Int, toIndex: Int) {
        CoreWorker.shared.reorderPairOnList(fromIndex: fromIndex, toIndex: toIndex)
    }
    
    func deletePair(index: Int) {
        CoreWorker.shared.deletePairFromFavoriteList(index: index)
    }
    

    
    
}

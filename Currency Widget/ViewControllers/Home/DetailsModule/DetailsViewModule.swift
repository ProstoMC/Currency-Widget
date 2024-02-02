//
//  DetailsViewModule.swift
//  Currency Widget
//
//  Created by macSlm on 21.12.2023.
//

import Foundation
import RxSwift

protocol DetailsViewModuleProtocol {
    var rxIsAppearFlag: BehaviorSubject<Bool> { get }
    var rxFavoriteStatus: BehaviorSubject<Bool> { get set }
    
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var colorSet: AppColors { get }
    
    func changeFavoriteStatus()
}

class DetailsViewModule: DetailsViewModuleProtocol {
    
    let bag = DisposeBag()
    
    var rxIsAppearFlag = RxSwift.BehaviorSubject(value: false) //hidden as default
    var rxFavoriteStatus = RxSwift.BehaviorSubject(value: false)
    
    var rxAppThemeUpdated = BehaviorSubject(value: false)
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()
    
    init() {
        subscribeToCoreWorker()
        getFavouriteStatus()
    }
    
    func changeFavoriteStatus() {
        
        do {
            let status = try rxFavoriteStatus.value()
            let from = CoreWorker.shared.exchangeWorker.fromCoin
            let to = CoreWorker.shared.exchangeWorker.toCoin

            if status {
                CoreWorker.shared.favouritePairList.deletePair(valueCode: from, baseCode: to)
            }
            else {
                CoreWorker.shared.favouritePairList.addNewPair(valueCode: from, baseCode: to, colorIndex: nil)
            }
            CoreWorker.shared.exchangeWorker.rxExchangeFlag.onNext(true)

        } catch {
            return
        }
    }
    
}

extension DetailsViewModule {
    
    private func subscribeToCoreWorker() {
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe { flag in
            self.rxIsAppearFlag.onNext(flag)
            self.getFavouriteStatus()
        }.disposed(by: bag)
        
        //Update colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            self.colorSet = CoreWorker.shared.colorsWorker.returnColors()
            self.rxAppThemeUpdated.onNext(true)
        }.disposed(by: bag)
    }
    
    private func getFavouriteStatus() {
        
        rxFavoriteStatus.onNext(
            CoreWorker.shared.favouritePairList.checkIsExist(
            valueCode: CoreWorker.shared.exchangeWorker.fromCoin,
            baseCode: CoreWorker.shared.exchangeWorker.toCoin)
        )
    }
}

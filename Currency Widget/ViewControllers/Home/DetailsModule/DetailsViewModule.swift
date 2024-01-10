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
    
    func changeFavoriteStatus()
}

class DetailsViewModule: DetailsViewModuleProtocol {
    
    let bag = DisposeBag()
    
    var rxIsAppearFlag = RxSwift.BehaviorSubject(value: false) //hidden as default
    var rxFavoriteStatus = RxSwift.BehaviorSubject(value: false)
    
    init() {
        subscribeToExchangeFlag()
        getFavouriteStatus()
    }
    
    func changeFavoriteStatus() {
        do {
            let status = try rxFavoriteStatus.value()
            let from = try CoreWorker.shared.rxExchangeFromCurrency.value()
            let to = try CoreWorker.shared.rxExchangeToCurrency.value()
            
            if status {
                CoreWorker.shared.deletePairFromFavoriteList(valueName: from, baseName: to)
            }
            else {
                CoreWorker.shared.addPairToFavoriteList(valueName: from, baseName: to)
            }
            CoreWorker.shared.rxExhangeFlag.onNext(true)

        } catch {
            return
        }
    }
    
}

extension DetailsViewModule {
    
    private func subscribeToExchangeFlag() {
        CoreWorker.shared.rxExhangeFlag.subscribe { flag in
            self.rxIsAppearFlag.onNext(flag)
            self.getFavouriteStatus()
        }.disposed(by: bag)
    }
    
    private func getFavouriteStatus() {
        do {
            let from = try CoreWorker.shared.rxExchangeFromCurrency.value()
            let to = try CoreWorker.shared.rxExchangeToCurrency.value()
            rxFavoriteStatus.onNext(CoreWorker.shared.isPairExistInFavoriteList(valueName: from, baseName: to))
        } catch {
            return
        }
    }
}

//
//  SettingsViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

protocol SettingsViewModelProtocol {
    var rxSettingsList: BehaviorRelay<[SectionOfSettings]> { get }
    var rxSettingsUpdated: BehaviorSubject<Bool> { get }
    func changeBaseCurrency(name: String)
}

class SettingsViewModel: SettingsViewModelProtocol {
    let bag = DisposeBag()
    
    var rxSettingsUpdated = RxSwift.BehaviorSubject<Bool>(value: false)
    
    var rxSettingsList: RxRelay.BehaviorRelay<[SectionOfSettings]>
    
    
    init() {
        //making empty array
        let section = SectionOfSettings(header: "Header", items: [])
        rxSettingsList = BehaviorRelay(value: [section]) 
        rxSettingsList.accept([section])
        
//        CoreWorker.shared.rxSettingsChangedFlag.subscribe { status in
//            self.rxSettingsUpdated.onNext(status)
//        }.disposed(by: bag)
    }
    
    func changeBaseCurrency(name: String) {
        //CoreWorker.shared.coinList.setBaseCoin(newCode: name)
    }
    

}



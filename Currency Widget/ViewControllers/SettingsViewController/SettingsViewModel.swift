//
//  SettingsViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 27.12.2023.
//

import Foundation
import RxSwift
import UIKit

struct SettingsCellViewModel {
    let name: String
    var value: BehaviorSubject<String>
    
    var nameLabelColor: BehaviorSubject<UIColor>
    var valueLabelColor: BehaviorSubject<UIColor>
    var backgroundColor: BehaviorSubject<UIColor>
}

protocol SettingsViewModelProtocol {
    var colorSet: AppColors { get }
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    
    var settingsList: [SettingsCellViewModel] { get }
    
    func changeBaseCurrency(name: String)
    func changeTheme(theme: AppTheme)
}

class SettingsViewModel: SettingsViewModelProtocol {
    var colorSet: AppColors = CoreWorker.shared.colorsWorker.returnColors()
    var rxAppThemeUpdated = BehaviorSubject(value: true)
    
    let bag = DisposeBag()

    var settingsList: [SettingsCellViewModel] = []
    
    init() {
        settingsList = createSettingsList()
        subscribing()
    }
    
    private func subscribing() {
        
        //Subscribe to Coin List
        CoreWorker.shared.coinList.rxRateUpdated.subscribe { _ in
            self.settingsList[0].value.onNext(CoreWorker.shared.coinList.baseCoin.code)
        }.disposed(by: bag)
        
        //Subscribe to Colors worker
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe { _ in
            //Update colors in VC
            self.changeColorSet()
            self.rxAppThemeUpdated.onNext(true)
            
            var valueName = ""
            switch CoreWorker.shared.colorsWorker.returnAppTheme() {
            case .dark: valueName = "Dark"
            case .light: valueName = "Light"
            case .system: valueName = "System"
            }
            
            self.settingsList[1].value.onNext(valueName)
            
        }.disposed(by: bag)

    }

    func changeBaseCurrency(name: String) {
        CoreWorker.shared.coinList.setBaseCoin(newCode: name)
    }
    
    func changeTheme(theme: AppTheme) {
        if theme != CoreWorker.shared.colorsWorker.returnAppTheme() {
            CoreWorker.shared.colorsWorker.newAppTheme(newTheme: theme)
        }
    }

}

extension SettingsViewModel {
    private func createSettingsList() -> [SettingsCellViewModel] {
        var list: [SettingsCellViewModel] = []
        //Add base coin form CoinList
        list.append(createBaseCurrencySettings())
        list.append(createThemeSettigs())

        return list
    }
    
    private func createBaseCurrencySettings() -> SettingsCellViewModel {
        return SettingsCellViewModel(
            name: "Base currency",
            value: BehaviorSubject(value: CoreWorker.shared.coinList.baseCoin.code),
            nameLabelColor: BehaviorSubject(value: colorSet.mainText),
            valueLabelColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.background)
        )
    }
    private func createThemeSettigs() -> SettingsCellViewModel {
        var valueName = ""
        
        switch CoreWorker.shared.colorsWorker.returnAppTheme() {
        case .dark: valueName = "Dark"
        case .light: valueName = "Light"
        case .system: valueName = "System"
        }
        
        return SettingsCellViewModel(
            name: "App Theme",
            value: BehaviorSubject(value: valueName),
            nameLabelColor: BehaviorSubject(value: colorSet.mainText),
            valueLabelColor: BehaviorSubject(value: colorSet.secondText),
            backgroundColor: BehaviorSubject(value: colorSet.background)
        )
    }
}

extension SettingsViewModel {
    private func changeColorSet() {
        colorSet = CoreWorker.shared.colorsWorker.returnColors()
        
        for i in settingsList.indices {
            settingsList[i].nameLabelColor.onNext(colorSet.mainText)
            settingsList[i].valueLabelColor.onNext(colorSet.secondText)
            settingsList[i].backgroundColor.onNext(colorSet.background)
        }
        
    }
}

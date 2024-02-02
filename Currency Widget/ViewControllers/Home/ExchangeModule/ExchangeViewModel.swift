//
//  ExchangeViewModel.swift
//  Currency Widget
//
//  Created by macSlm on 28.11.2023.
//

import Foundation
import RxSwift



protocol ExchangeViewModelProtocol {
    var fromText: BehaviorSubject<String> {get set}
    var toText: BehaviorSubject<String> {get set}
    var fromCurrency: BehaviorSubject<String> {get set}
    var toCurrency: BehaviorSubject<String> {get set}
    
    var rxAppThemeUpdated: BehaviorSubject<Bool> { get }
    var colorSet: AppColors { get }
    
    func makeExchangeNormal()
    func makeExchangeReverse()
    func switchFields()
    func setCurrency(shortName: String, type: String)
    
}

class ExchangeViewModel: ExchangeViewModelProtocol  {
    
    var rxAppThemeUpdated = BehaviorSubject(value: false)
    var colorSet = CoreWorker.shared.colorsWorker.returnColors()
    
    var fromText = RxSwift.BehaviorSubject<String>(value: "1")
    var toText = RxSwift.BehaviorSubject<String>(value: "1")
    var fromCurrency = BehaviorSubject<String>(value: "RUB")
    var toCurrency = BehaviorSubject<String>(value: "USD")
    
    let disposeBag = DisposeBag()
    //let formatter = NumberFormatter().numberStyle = .decimal
    
    init() {
        subscrubeToCoreWorker()
    }
    
    private func subscrubeToCoreWorker() {
        // Update after fetching currency rates
        CoreWorker.shared.coinList.rxRateUpdated.subscribe(onNext: {_ in
            self.makeExchangeNormal()
        }).disposed(by: disposeBag)
        
        //Update exchanging and fields after new currency on the fields
        CoreWorker.shared.exchangeWorker.rxExchangeFlag.subscribe({ _ in
            self.fromCurrency.onNext(CoreWorker.shared.exchangeWorker.fromCoin)
            self.toCurrency.onNext(CoreWorker.shared.exchangeWorker.toCoin)
            self.makeExchangeNormal()
        }).disposed(by: disposeBag)
        
        //Update colors
        CoreWorker.shared.colorsWorker.rxAppThemeUpdated.subscribe{ _ in
            self.colorSet = CoreWorker.shared.colorsWorker.returnColors()
            self.rxAppThemeUpdated.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func makeExchangeNormal() {
        do {
            let fromValue = convertStringToDouble(text: try fromText.value())
            let fromRate = CoreWorker.shared.coinList.returnCoin(code: try fromCurrency.value())?.rate ?? 1
            let toRate = CoreWorker.shared.coinList.returnCoin(code: try toCurrency.value())?.rate ?? 1
            
            let rate = toRate/fromRate
            let value = fromValue/rate
            let valueText = String(Double(round(100*value)/100))
            toText.onNext(valueText)
        } catch {
            return
        }
    }
    
    func makeExchangeReverse() {
        do {
            let fromValue = convertStringToDouble(text: try toText.value())
            let fromRate = CoreWorker.shared.coinList.returnCoin(code: try fromCurrency.value())?.rate ?? 1
            let toRate = CoreWorker.shared.coinList.returnCoin(code: try toCurrency.value())?.rate ?? 1
            
            let rate = fromRate/toRate
            let value = fromValue/rate
            let valueText = String(Double(round(100*value)/100))
            fromText.onNext(valueText)
        } catch {
            return
        }
    }
    
    func switchFields() {
        CoreWorker.shared.exchangeWorker.switchRows()
    }
    
    func setCurrency(shortName: String, type: String) {
        print("--Setted currency = \(shortName) -- type = \(type)")
        if type == "From" {
            CoreWorker.shared.exchangeWorker.setFromCoin(code: shortName)
        }
        if type == "To" {
            CoreWorker.shared.exchangeWorker.setToCoin(code: shortName)
        }
        
    }
    
}

extension ExchangeViewModel {
    
    private func convertStringToDouble(text: String) -> Double {
        let formatter = NumberFormatter()
        if let value = Double(text) {
            return value
        }
        formatter.decimalSeparator = ","
        if let value = NumberFormatter().number(from: text)?.doubleValue {
            return value
        }
        return 0
    }
}

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
    
    func makeExchangeNormal()
    func makeExchangeReverse()
    func setFields(fromName: String, toName: String)
    func switchFields()
    
}

class ExchangeViewModel: ExchangeViewModelProtocol  {
    
    var fromText = RxSwift.BehaviorSubject<String>(value: "1")
    var toText = RxSwift.BehaviorSubject<String>(value: "1")
    var fromCurrency = BehaviorSubject<String>(value: "RUB")
    var toCurrency = BehaviorSubject<String>(value: "USD")
    
    let disposeBag = DisposeBag()
    //let formatter = NumberFormatter().numberStyle = .decimal
    
    init() {
        // Chust for update after fetching currency rates
        CurrencyList.shared.getCurrency(name: "USD").rateRx.subscribe(onNext: { rate in
            self.makeExchangeNormal()
            print(rate)
        }).disposed(by: disposeBag)
    }
    
    func makeExchangeNormal() {
        do {
            let fromValue = convertStringToDouble(text: try fromText.value())
            let fromRate = try CurrencyList.shared.getCurrency(name: try fromCurrency.value()).rateRx.value()
            let toRate = try CurrencyList.shared.getCurrency(name: try toCurrency.value()).rateRx.value()
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
            let fromRate = try CurrencyList.shared.getCurrency(name: try fromCurrency.value()).rateRx.value()
            let toRate = try CurrencyList.shared.getCurrency(name: try toCurrency.value()).rateRx.value()
            let rate = fromRate/toRate
            let value = fromValue/rate
            let valueText = String(Double(round(100*value)/100))
            fromText.onNext(valueText)
        } catch {
            return
        }
    }
    
    func setFields(fromName: String, toName: String) {
        print("setFields")
        
    }
    
    func switchFields() {
        print("switchFields")
        do {
            let newFromName = try toCurrency.value()
            toCurrency.onNext(try fromCurrency.value())
            fromCurrency.onNext(newFromName)
            makeExchangeNormal()
        }catch {
            return
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
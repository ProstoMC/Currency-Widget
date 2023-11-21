//
//  File.swift
//  Currency Widget
//
//  Created by macSlm on 26.10.2023.
//

import Foundation
import Alamofire

struct JSONStruct: Decodable {
    let disclaimer: String
    let date: String
    let base: String
    let rates: [String: Double]
}

class CurrencyFetcher {
    static let shared = CurrencyFetcher()
//    var baseCurrency = Currency (rate: 1, base: "USD", shortName: "USD") //DEFAULT
//    var currency: [Currency] = []
    var json: JSONStruct!
    
    
    func fetchCurrency(completion: @escaping () -> ()) {
        let url = "https://www.cbr-xml-daily.ru/latest.js"
        
        AF.request(url).validate().responseDecodable(of: JSONStruct.self) { (response) in
            DispatchQueue.main.async {
                self.json = response.value!
                //self.baseCurrency = Currency (rate: 1, base: self.json.base, shortName: self.json.base)
                CurrencyList.shared.setBaseCurrency(name: self.json.base)
                for rate in self.json.rates {
                    //self.currency.append(Currency(rate: rate.value, base: self.json.base, shortName: rate.key))
                    //print("\(rate.key) = \(rate.value)")
                    CurrencyList.shared.setCurrencyValue(name: rate.key, value: rate.value)
                }
                
                completion()
            }
        }.resume()
        
    }
}

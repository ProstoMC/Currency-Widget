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
    var currency: [Currency] = []
    var json: JSONStruct!
    
    func fetchCurrency(completion: @escaping () -> ()) {
        let url = "https://www.cbr-xml-daily.ru/latest.js"
        
        AF.request(url).validate().responseDecodable(of: JSONStruct.self) { (response) in
            //print (response)
            DispatchQueue.main.async {
                self.json = response.value!
                //print (json.rates)
                for rate in self.json.rates {
                    self.currency.append(Currency(rate: rate.value, base: self.json.base, shortName: rate.key))
                }
                print (self.json.base)
                completion()
            }
        }.resume()
        
    }
}

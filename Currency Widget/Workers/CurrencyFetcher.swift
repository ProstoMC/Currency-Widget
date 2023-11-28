//
//  File.swift
//  Currency Widget
//
//  Created by macSlm on 26.10.2023.
//

import Foundation
import Alamofire

struct Valute: Decodable {
    let ID: String
    let NumCode: String
    let CharCode: String
    let Nominal: Double
    let Name: String
    let Value: Double
    let Previous: Double
}

struct DailyJSONStruct: Decodable {
    let Date: String
    let PreviousDate: String
    let PreviousURL: String
    let Timestamp: String
    let Valute: [String: Valute]
}

class CurrencyFetcher {
    static let shared = CurrencyFetcher()
    
    func fetchCurrencyDaily(completion: @escaping () -> ()) {
        CurrencyList.shared.setBaseCurrency(name: "RUB")
        let url = "https://www.cbr-xml-daily.ru/daily_json.js"
        AF.request(url).validate().responseDecodable(of: DailyJSONStruct.self) { (response) in
            DispatchQueue.main.async {
                guard let dailyJSON = response.value else { return }
                for currency in dailyJSON.Valute {
                    
                    let charCode = currency.value.CharCode
                    let value = currency.value.Value
                    let previousValue = currency.value.Previous
                    //let name = currency.value.Name  //It is russian name
                    
                    CurrencyList.shared.setCurrencyValue(name: charCode, value: value, previousValue: previousValue)
                }
                completion()
            }
        }.resume()
    }

}

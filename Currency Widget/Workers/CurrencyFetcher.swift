//
//  File.swift
//  Currency Widget
//
//  Created by macSlm on 26.10.2023.
//

import Foundation
import Alamofire


class CurrencyFetcher {
    
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
    
    
    func fetchCurrencyDaily(completion: @escaping ([String: Valute]) -> ()) {
//        CurrencyList.shared.setBaseCurrency(name: "RUB")
        let url = "https://www.cbr-xml-daily.ru/daily_json.js"
        AF.request(url).validate().responseDecodable(of: DailyJSONStruct.self) { (response) in
            DispatchQueue.main.async {
                guard let dailyJSON = response.value else { return }
                completion(dailyJSON.Valute)
            }
        }.resume()
    }

}

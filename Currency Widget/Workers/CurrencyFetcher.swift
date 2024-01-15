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
    
    func fetchCurrencyDaily(completion: @escaping ([String: Valute], String) -> ()) {
//        CurrencyList.shared.setBaseCurrency(name: "RUB")
        let url = "https://www.cbr-xml-daily.ru/daily_json.js"
        AF.request(url).validate().responseDecodable(of: DailyJSONStruct.self) { (response) in
            
            guard let dailyJSON = response.value else { return }
            
            DispatchQueue.main.async {
                completion(dailyJSON.Valute, dailyJSON.Date)
            }
        }.resume()
    }
    
    
    func updateCoinRates(base: String, coinCodes: String, completion: @escaping ([String: Any]) -> Void) {
        let apiKey = "&api_key=3c41c3d404a031315ab977afcc356495d04a7933ae49479e8d59a8834ba14268" //Add to end of request
        let responseHeader = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms="
        
        let base = "&tsyms=" + base
        let url = responseHeader + coinCodes + base + apiKey //Creating Resquest
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else { return }
            
            //print (String(decoding: data, as: UTF8.self))
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let coinsList = json["RAW"] as! [String: Any]
                
                completion(coinsList)
            } catch {
                print(error)
            }
        }.resume()
        
        
    }

}

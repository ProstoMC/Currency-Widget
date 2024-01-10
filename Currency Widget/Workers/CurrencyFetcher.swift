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
    
    //For https://min-api.cryptocompare.com/data/top/totalvolfull?limit=40&tsym=RUB&api_key=
    
    struct CryptoCoin: Decodable {
        let Id: Int
        let Name: String
        let FullName: String
        
    }
    
    struct CryptoJSON: Decodable {
        let Message: String
        struct Data: Decodable {
            struct CoinInfo: Decodable {
                let Id: String
                let Name: String
                let FullName: String
                let ImageUrl: String
            }
            let CoinInfo: CoinInfo
        }
        let Data: [Data]
    }
    
            struct CoinProperty: Codable {
                let FROMSYMBOL: String
                let TOSYMBOL: String
                //let PRICE: String
                //let LASTUPDATE: Int
                //let CHANGE24HOUR: Double
            }
    
//    struct CoinList: Codable {
//        let USD:
//    }
    
    
    
    struct UniversalCoinJSON {

//        let dic: [String:ValueData]
        let RAW: [String: Any]
    }
    
    
    func fetchCurrencyDaily(completion: @escaping ([String: Valute], String) -> ()) {
//        CurrencyList.shared.setBaseCurrency(name: "RUB")
        let url = "https://www.cbr-xml-daily.ru/daily_json.js"
        AF.request(url).validate().responseDecodable(of: DailyJSONStruct.self) { (response) in
            
            guard let dailyJSON = response.value else { return }
            
            //Part For Universal
            
            //Find Base Coin
            var baseValueInRUB = 1.0
            for coin in dailyJSON.Valute {
                if coin.value.CharCode == fiatList[0].base {
                    baseValueInRUB = coin.value.Value
                }
            }
            //Update rates
            for coin in dailyJSON.Valute {
                for i in fiatList.indices {
                    if fiatList[i].code == coin.value.CharCode {
                        fiatList[i].rate = coin.value.Value/baseValueInRUB
                        fiatList[i].flow24Hours = (coin.value.Value - coin.value.Previous)/baseValueInRUB
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(dailyJSON.Valute, dailyJSON.Date)
            }
        }.resume()
    }
    
    func updateRatesFromCryptoCompare(completion: @escaping (Bool) -> ()) {
        let apiKey = "&api_key=3c41c3d404a031315ab977afcc356495d04a7933ae49479e8d59a8834ba14268" //Add to end of request
        let responseHeader = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms="
        
        let base = "&tsyms=" + fiatList[0].base
        
        var coinsCodes = ""
        
        for element in fiatList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        for element in cryptoList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        
        //print(coinsCodes)
        
        let url = responseHeader + coinsCodes + base + apiKey
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else { return }
            
            //print (String(decoding: data, as: UTF8.self))
            do {
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let coinsList = json["RAW"] as! [String: Any]
                for i in fiatList.indices {
                    guard let coinsProperty = coinsList[fiatList[i].code] as? [String: Any] else { continue }
                    guard let properties = coinsProperty[fiatList[i].base] as? [String: Any] else { continue }
                    
                    guard let rate = properties["PRICE"] as? Double else { continue }
                    guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
                    
                    fiatList[i].rate = rate
                    fiatList[i].flow24Hours = flow
                }
                
                for i in cryptoList.indices {
                    guard let coinsProperty = coinsList[cryptoList[i].code] as? [String: Any] else { continue }
                    guard let properties = coinsProperty[cryptoList[i].base] as? [String: Any] else { continue }
                    
                    guard let rate = properties["PRICE"] as? Double else { continue }
                    guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
                    
                    cryptoList[i].rate = rate
                    cryptoList[i].flow24Hours = flow
                }
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }.resume()
    }

}

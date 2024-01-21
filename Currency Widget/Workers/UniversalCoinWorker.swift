//
//  UniversalCoinWorker.swift
//  Currency Widget
//
//  Created by macSlm on 11.01.2024.
//

import Foundation
import RxSwift

protocol CoinListProtocol {
    var baseCoin: CoinUniversal { get }
    var lastUpdate: String { get }
    var fiatList: [CoinUniversal] { get }
    var cryptoList: [CoinUniversal] { get }
    var rxRateUpdated: BehaviorSubject<Bool> { get }
    
    func updateRatesFromEth()
    func returnCoin(code: String) -> CoinUniversal?
    func setBaseCoin(newCode: String)
}



class UniversalCoinWorker {
    var rxRateUpdated = BehaviorSubject(value: false)

    var baseCoin = CoinUniversal(type: .fiat, code: "USD", name: "United States Dollar", base: "USD", rate: 1, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 2)
    var lastUpdate = "Error"
    var fiatList: [CoinUniversal] = []
    var cryptoList: [CoinUniversal] = []
    
    let fetcher = CurrencyFetcher()
    let defaults = UserDefaults.standard
    let bag = DisposeBag()
    
    init() {
        rxSubscribing()
        getFromDefaulst()
        updateRatesFromEth()
        
    }
    
    func rxSubscribing() {
        rxRateUpdated.subscribe{ success in
            if success {
                self.saveCoinsToDefaults()
            }
        }.disposed(by: bag)
    }
    
    func returnFiatList() -> [CoinUniversal] {
        return fiatList
    }
    
    func returnBaseCode() -> String {
        return baseCoin.code
    }

}

extension UniversalCoinWorker: CoinListProtocol {
    func updateRatesFromEth() {
        
        //FETCHING FROM CB
        fetcher.fetchCurrencyDaily(completion: { valuteList, _ in
            var baseRate = 1.0
            //Finding Base Currency for convert from RUB
            for currency in valuteList {
                if currency.value.CharCode == self.baseCoin.code {
                    baseRate = currency.value.Value
                    break
                }
            }
            
            for currency in valuteList {
                //let name = currency.value.Name  //It is russian name
                self.updateRatesFromCB(
                    code: currency.value.CharCode,
                    rate: currency.value.Value/baseRate,
                    flow: (currency.value.Value - currency.value.Previous)/baseRate)
            }
        })
        
        //FETCHING FROM CRYPTOMARKET
        
        //Preparing Codes for request
        var coinsCodes = ""
        
        for element in fiatList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        for element in cryptoList {
            coinsCodes.append(element.code)
            coinsCodes.append(",")
        }
        // Request
        fetcher.updateCoinRates(base: "USD", coinCodes: coinsCodes, completion: { list in
            self.updateRates(json: list)
            DispatchQueue.main.async {
                self.rxRateUpdated.onNext(true)
            }
        })
    }
    
    func returnCoin(code: String) -> CoinUniversal? {
        for coin in fiatList {
            if coin.code == code {
                return coin
            }
        }
        for coin in cryptoList {
            if coin.code == code {
                return coin
            }
        }
        return nil
    }
    
    func setBaseCoin(newCode: String) {
        guard let newBaseCoin = returnCoin(code: newCode) else { return }
        let ratio = newBaseCoin.rate / baseCoin.rate
        for i in fiatList.indices {
            fiatList[i].rate = fiatList[i].rate / ratio
            fiatList[i].flow24Hours = fiatList[i].flow24Hours / ratio
        }
        baseCoin = returnCoin(code: newCode)! // Get updated values. And we've checked existing in first line
        rxRateUpdated.onNext(true)
    }
    
}

//MARK: - ETHERNET

extension UniversalCoinWorker {
    func updateRatesFromCB(code: String, rate: Double, flow: Double) {
        
        for i in fiatList.indices {
            if code == fiatList[i].code {
                fiatList[i].rate = rate
                fiatList[i].flow24Hours = flow
                break
            }
        }
    }
    
    func updateRates(json: [String : Any]) {
        //Set previous rate in USD
        var baseRate = returnCoin(code: "USD")!.rate
        
        //Find Last Update and Base Currency for convert from USD
        if let coinsProperty = json[baseCoin.code] as? [String: Any] {
            if let properties = coinsProperty["USD"] as? [String: Any] {
                //Set rate
                if let rate = properties["PRICE"] as? Double {
                    baseRate = rate
                }
                //Set date
                if let date = properties["LASTUPDATE"] as? Int {
                    // convert Int to TimeInterval (typealias for Double)
                    let timeInterval = TimeInterval(date)
                    // create NSDate from Double (NSTimeInterval)
                    let nsDate = Date(timeIntervalSince1970: timeInterval)
   
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY.MM.dd HH:mm"
                    
                    lastUpdate = dateFormatter.string(from: nsDate)
                }
            }
            
        }
        
        for i in fiatList.indices {
            guard let coinsProperty = json[fiatList[i].code] as? [String: Any] else { continue }
            guard let properties = coinsProperty["USD"] as? [String: Any] else { continue }
            
            guard let rate = properties["PRICE"] as? Double else { continue }
            guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
            var imageUrl = properties["IMAGEURL"] as? String ?? "Error"
            
            if imageUrl == "/media/35309345/no-image.png" { //Prefere dont have image then this image
                imageUrl = "Error"
            }
            
            fiatList[i].rate = rate / baseRate
            fiatList[i].flow24Hours = flow / baseRate
            fiatList[i].imageUrl = "https://www.cryptocompare.com" + imageUrl
        }
        
        for i in cryptoList.indices {
            guard let coinsProperty = json[cryptoList[i].code] as? [String: Any] else { continue }
            guard let properties = coinsProperty["USD"] as? [String: Any] else { continue }
            
            guard let rate = properties["PRICE"] as? Double else { continue }
            guard let flow = properties["CHANGE24HOUR"] as? Double else { continue }
            var imageUrl = properties["IMAGEURL"] as? String ?? "Error"
            
            if imageUrl == "/media/35309345/no-image.png" { //Prefere dont have image then this image
                imageUrl = "Error"
            }
            
            cryptoList[i].rate = rate / baseRate
            cryptoList[i].flow24Hours = flow / baseRate
            cryptoList[i].imageUrl = "https://www.cryptocompare.com" + imageUrl
        }
    }
    
}

    
// MARK: - USER DEFAULTS
extension UniversalCoinWorker {

    func saveCoinsToDefaults() {
        let encoder = JSONEncoder()
        
        if let fiats = try? encoder.encode(fiatList) {
            defaults.set(fiats, forKey: TypeOfCoin.fiat.rawValue)
            print("--Fiats was saved--")
        }
        if let coins = try? encoder.encode(cryptoList) {
            defaults.set(coins, forKey: TypeOfCoin.crypto.rawValue)
            print("--Coins was saved--")
        }
        if let base = try? encoder.encode(baseCoin){
            defaults.set(base, forKey: "baseCoin")
            print("--Base coin was saved--")
        }
        defaults.set(lastUpdate, forKey: "lastUpdate")
    }
    
    func getFromDefaulst() {
        //Get coins
        fiatList = getCoinsFromDefaults(type: .fiat)
        if fiatList.isEmpty {
            fiatList = createFiatList()
        }
        cryptoList = getCoinsFromDefaults(type: .crypto)
        if cryptoList.isEmpty {
            cryptoList = createCryptoList()
        }
        //Get baseCoin
        let coin = getBaseCoinFromDefaults()
        if coin == nil {
            setBaseCoin(newCode: "USD")
        } else {
            baseCoin = coin!
        }
        //Get lastUpdate
        let date = getLastUpdateFromDefaults()
        if date == nil {
            lastUpdate = "Error"
        } else {
            lastUpdate = date!
        }
        
        rxRateUpdated.onNext(true)
    }
    
    func getCoinsFromDefaults(type: TypeOfCoin) -> [CoinUniversal] {
        
        var list: [CoinUniversal] = []
        
        if let savedData = defaults.object(forKey: type.rawValue) as? Data {
            let decoder = JSONDecoder()
            do {
                let savedList = try decoder.decode([CoinUniversal].self, from: savedData)
                list = savedList
            }
            catch { list = [] }
        }
        return list
    }
    func getBaseCoinFromDefaults() -> CoinUniversal? {
        
        if let savedData = defaults.object(forKey: "baseCoin") as? Data {
            let decoder = JSONDecoder()
            do {
                let coin = try decoder.decode(CoinUniversal.self, from: savedData)
                return coin
            }
            catch { return nil }
        }
        return nil
    }
    func getLastUpdateFromDefaults() -> String? {
        return defaults.object(forKey: "lastUpdate") as? String
    }
    
}

// MARK: - DEFAULT LISTS
extension UniversalCoinWorker {
    private func createFiatList() -> [CoinUniversal] {
        return [
            CoinUniversal(type: .fiat, code: "RUB", name: "Russian Ruble", base: "USD", rate: 0, flow24Hours: 0, logo: "₽", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "AUD", name: "Australian Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "A$", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "AZN", name: "Azerbaijani Manat", base: "USD", rate: 0, flow24Hours: 0, logo: "₼", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "GBP", name: "British Pound Sterling", base: "USD", rate: 0, flow24Hours: 0, logo: "£", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "AMD", name: "Armenian Dram", base: "USD", rate: 0, flow24Hours: 0, logo: "֏", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "BYN", name: "Belarusian Ruble", base: "USD", rate: 0, flow24Hours: 0, logo: "Br", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "BGN", name: "Bulgarian Lev", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "BRL", name: "Brazilian Real", base: "USD", rate: 0, flow24Hours: 0, logo: "R$", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "HUF", name: "Hungarian Forint", base: "USD", rate: 0, flow24Hours: 0, logo: "Ft", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "VND", name: "Vietnamese Dong", base: "USD", rate: 0, flow24Hours: 0, logo: "₫", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "HKD", name: "Hong Kong Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "₫", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "GEL", name: "Georgian Lari", base: "USD", rate: 0, flow24Hours: 0, logo: "₾", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "DKK", name: "Danish Krone", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "AED", name: "UAE Dirham", base: "USD", rate: 0, flow24Hours: 0, logo: "د.إ", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "USD", name: "United States Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "EUR", name: "Euro", base: "USD", rate: 0, flow24Hours: 0, logo: "€", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "EGP", name: "Egyptian Pound", base: "USD", rate: 0, flow24Hours: 0, logo: "E£", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "INR", name: "Indian Rupee", base: "USD", rate: 0, flow24Hours: 0, logo: "₹", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "IDR", name: "Indonesian Rupiah", base: "USD", rate: 0, flow24Hours: 0, logo: "Rp", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "KZT", name: "Kazakhstani Tenge", base: "USD", rate: 0, flow24Hours: 0, logo: "₸", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "CAD", name: "Canadian Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "$", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "QAR", name: "Qatari Rial", base: "USD", rate: 0, flow24Hours: 0, logo: "﷼", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "KGS", name: "Kyrgystani Som", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "CNY", name: "Chinese Yuan", base: "USD", rate: 0, flow24Hours: 0, logo: "¥", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "MDL", name: "Moldovan leu", base: "USD", rate: 0, flow24Hours: 0, logo: "L", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "NZD", name: "New Zealand Dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "NZ$", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "NOK", name: "Norwegian Krone", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "PLN", name: "Polish Zloty", base: "USD", rate: 0, flow24Hours: 0, logo: "zł", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "RON", name: "Romanian Leu", base: "USD", rate: 0, flow24Hours: 0, logo: "RON", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "XDR", name: "Special Drawing Rights", base: "USD", rate: 0, flow24Hours: 0, logo: "XDR", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "SGD", name: "Singapore dollar", base: "USD", rate: 0, flow24Hours: 0, logo: "S$", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "TJS", name: "Tajikistani somoni", base: "USD", rate: 0, flow24Hours: 0, logo: "TJS", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "THB", name: "Thai baht", base: "USD", rate: 0, flow24Hours: 0, logo: "฿", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "TRY", name: "Turkish Lira", base: "USD", rate: 0, flow24Hours: 0, logo: "₺", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "TMT", name: "Turkmenistani Manat", base: "USD", rate: 0, flow24Hours: 0, logo: "T", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "UZS", name: "Uzbekistan Som", base: "USD", rate: 0, flow24Hours: 0, logo: "лв", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "UAH", name: "Ukranian Hryvnia", base: "USD", rate: 0, flow24Hours: 0, logo: "₴", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "CZK", name: "Czech Koruna", base: "USD", rate: 0, flow24Hours: 0, logo: "Kč", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "SEK", name: "Swedish Krona", base: "USD", rate: 0, flow24Hours: 0, logo: "kr", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "CHF", name: "Swiss Franc", base: "USD", rate: 0, flow24Hours: 0, logo: "₣", imageUrl: "", colorIndex: 3),
            CoinUniversal(type: .fiat, code: "RSD", name: "Serbian Dinar", base: "USD", rate: 0, flow24Hours: 0, logo: "РСД", imageUrl: "", colorIndex: 0),
            CoinUniversal(type: .fiat, code: "ZAR", name: "South African Rand", base: "USD", rate: 0, flow24Hours: 0, logo: "R", imageUrl: "", colorIndex: 1),
            CoinUniversal(type: .fiat, code: "KRW", name: "Korean Won", base: "USD", rate: 0, flow24Hours: 0, logo: "₩", imageUrl: "", colorIndex: 2),
            CoinUniversal(type: .fiat, code: "JPY", name: "Japanese Yen", base: "USD", rate: 0, flow24Hours: 0, logo: "¥", imageUrl: "", colorIndex: 3),
        ]
    }
    
    private func createCryptoList() -> [CoinUniversal] {
        return [
            CoinUniversal(type: .crypto, code: "BTC", name: "Bitcoin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746251/btc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ETH", name: "Ethereum", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746238/eth.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SOL", name: "Solana", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37747734/sol.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "XRP", name: "XRP", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/38553096/xrp.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ARB", name: "Arbitrum", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44081950/arb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "USDC", name: "USD Coin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/34835941/usdc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "FDUSD", name: "First Digital USD", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44154091/fdusd.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "DOGE", name: "Dogecoin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746339/doge.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "USDT", name: "Tether", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746338/usdt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "AVAX", name: "Avalanche", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/43977160/avax.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "OP", name: "Optimism", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/40219338/op.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ADA", name: "Cardano", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746235/ada.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BNB", name: "Binance Coin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/40485170/bnb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "MATIC", name: "Polygon", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746047/matic.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LINK", name: "Chainlink", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746242/link.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "WSB", name: "WallStreetBets DApp", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/39383061/wsb.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BONK", name: "Bonk", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/43977068/bonk.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LTC", name: "Litecoin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746243/ltc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ETC", name: "Ethereum Classic", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746862/etc.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "LDO", name: "Lido DAO", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/40485192/ldo.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TIA", name: "Celestia", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44154182/tia.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "FIL", name: "FileCoin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37747014/fil.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "MANTLE", name: "Mantle", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44154179/mantle.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SEI", name: "Sei", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44082123/sei.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "INJ", name: "Injective", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/43687858/inj.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SHIB", name: "Shiba Inu", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37747199/shib.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BCH", name: "Bitcoin Cash", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746245/bch.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ICP", name: "Internet Computer", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37747502/icp.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "STX", name: "Stacks", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746986/stx.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "DOT", name: "Polkadot", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/39334571/dot.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TRX", name: "TRON", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37746879/trx.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "NEAR", name: "Near", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/37458963/near.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "PEOPLE", name: "ConstitutionDAO", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/39198201/people.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "ENS", name: "Ethereum Name Service", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/38554045/ens.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "APT", name: "Aptos", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/43881360/apt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "SUI", name: "Sui", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44082045/sui.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "TUSD", name: "True USD", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/38554125/tusd.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "GMT", name: "STEPN", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/39838490/gmt.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "BSV", name: "Bitcoin SV", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/44082082/bsv.png", colorIndex: -1),
            CoinUniversal(type: .crypto, code: "WBTC", name: "Wrapped Bitcoin", base: "USD", rate: 0, flow24Hours: 0, logo: "", imageUrl: "www.cryptocompare.com/media/35309588/wbtc.png", colorIndex: -1),
        ]
    }
    
}

//
//  CoreWorker.swift
//  Currency Widget
//
//  Created by macSlm on 12.12.2023.



//  Main worker, core of app

//  Launched from TabBar View Controller

import Foundation
import RxSwift

class CoreWorker {
    
    static let shared = CoreWorker()
    
    let bag = DisposeBag()
    
    
    //Currency List
    let currencyList: CurrencyListProtocol = CurrencyList()
    
    //Currency Pairs
    public var favoritePairList: [CurrencyPair] = []
    public let rxFavouritPairsCount = BehaviorSubject<Int>(value: 0)
    
    //Exchange values
    public let rxExhangeFlag = BehaviorSubject<Bool>(value: false) // Used for hide and unhide Details
    public let rxExchangeFromCurrency = BehaviorSubject<String>(value: "RUB")
    public let rxExchangeToCurrency = BehaviorSubject<String>(value: "USD")
    
    //Updating date
    public let rxUptadingDate = BehaviorSubject<String>(value: "Error")
    
    //Workers
    let currencyFetcher = CurrencyFetcher()
    let userDefaultsWorker = UserDefaultsWorker()
    
    init() {
        rxSubscribing()
        getPairsFromDefaults()
        getCurrencyValuesFromDefaults()
        
        fetchDataFromEthAndSaveToDefaults()
        
    }
    
// MARK:  - RX Subscribing
    private func rxSubscribing() { //Something changed. We must renumerate positions and save
        rxFavouritPairsCount.subscribe{ count in
            print("=FLAG-favorite pairs count = \(count)")
            self.renumeratePair()
            self.savePairsToDefaults()
        }.disposed(by: bag)
        
        rxUptadingDate.subscribe {_ in
            print("=FLAG-updating date")
            self.getCurrencyValuesFromDefaults()
        }.disposed(by: bag)
    }

}

// MARK:  - Ethernet
extension CoreWorker {

    private func fetchDataFromEthAndSaveToDefaults() {
        //BaseCurrency is RUB
        currencyFetcher.fetchCurrencyDaily(completion: { valuteList, lastUpdate in
            let baseCurrency = "RUB"
            //Input date: 2023-12-22T11:30:00+03:00
            let onlyDate = lastUpdate.components(separatedBy: "T") //2023-12-22 + 11:30:00+03:00
            let dateArray = onlyDate[0].components(separatedBy: "-") // 2023 + 12 + 22
            let normalDate = dateArray[2] + "." + dateArray[1] + "." + dateArray[0]
            
            var listForSaving = CurrencyListForDefaults(lastUpdate: normalDate, currencyValues: [])
            //Processing Data to saving
            for currency in valuteList {
                //let name = currency.value.Name  //It is russian name

                listForSaving.currencyValues.append(CurrencyValuesForDefaults(
                    shortName: currency.value.CharCode,
                    rate: currency.value.Value / currency.value.Nominal,
                    previousRate: currency.value.Previous / currency.value.Nominal,
                    base: baseCurrency,
                    colorIndex: self.currencyList.getCurrency(name: currency.value.CharCode).colorIndex)
                )

            }
            //Save to defaults
            
            self.userDefaultsWorker.saveCurrencyListToDefaults(currencyList: listForSaving)
            //Make flag for updatingvalues
            self.rxUptadingDate.onNext(normalDate)
            
        })
    }
}

// MARK:  - Currency Pair Module
extension CoreWorker {
    func isPairExistInFavoriteList(valueName: String, baseName: String) -> Bool {
        var status = false
        for pair in favoritePairList {
            if pair.valueCurrencyShortName == valueName && pair.baseCurrencyShortName == baseName {
                status = true
            }
        }
        return status
    }
    
    func addPairToFavoriteList(valueName: String, baseName: String){
        var pairExist = false
        for pair in favoritePairList {
            if pair.valueCurrencyShortName == valueName && pair.baseCurrencyShortName == baseName {
                pairExist = true
            }
        }
        if !pairExist {
            print("ADDING")
            favoritePairList.append(CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: valueName),
                baseCurrency: currencyList.getCurrency(name: baseName),
                position: currencyList.getlistCount())
            )
            //Push for updating view
            rxFavouritPairsCount.onNext(favoritePairList.count)
            
        }

    }
    
    func deletePairFromeFavoriteList(valueName: String, baseName: String) {
        var deleteIndex = -1
        for (index, pair) in favoritePairList.enumerated(){
            if pair.valueCurrencyShortName == valueName && pair.baseCurrencyShortName == baseName {
                deleteIndex = index
            }
        }
        if deleteIndex >= 0 {
            print("Delete index = \(deleteIndex)")
            favoritePairList.remove(at: deleteIndex)
        }
        //Push for updating view
        rxFavouritPairsCount.onNext(favoritePairList.count)
        
    }
    
    func deleteAllFavoritePairs(){
        favoritePairList.removeAll()
        rxFavouritPairsCount.onNext(favoritePairList.count)
    }
    
    private func renumeratePair() {
        for i in favoritePairList.indices {
            favoritePairList[i].position = i
        }
    }
}

// MARK:  - Exchange Module
extension CoreWorker {
    func setFromCurrencyExchange(name: String){
        rxExchangeFromCurrency.onNext(name)
        rxExhangeFlag.onNext(true)
        
    }
    func setToCurrencyExchange(name: String) {
        rxExchangeToCurrency.onNext(name)
        rxExhangeFlag.onNext(true)
    }
    
    func switchExchangeFields() {
        print("switchFields")
        do {
            let newFromName = try rxExchangeToCurrency.value()
            rxExchangeToCurrency.onNext(try rxExchangeFromCurrency.value())
            rxExchangeFromCurrency.onNext(newFromName)
            rxExhangeFlag.onNext(true)
        }catch {
            return
        }
    }
}

// MARK:  - User Defaults
extension CoreWorker {
    func savePairsToDefaults() {
        var list = PairListForDefaults(pairs: [])
        
        favoritePairList.forEach { pair in
            list.pairs.append(PairForDefaults(
                valueName: pair.valueCurrencyShortName,
                baseName: pair.baseCurrencyShortName,
                position: pair.position))
        }
        userDefaultsWorker.savePairsToDefaults(pairListForDefaults: list)
    }
    func getPairsFromDefaults() {
        var listFromDefaults = userDefaultsWorker.getPairsFromDefaults()
        print(listFromDefaults.pairs.count)
        //Check null array and then making one Tile
        if listFromDefaults.pairs.count == 0 {
            favoritePairList.append(CurrencyPair(
                valueCurrency: currencyList.getCurrency(name: "USD"),
                baseCurrency: currencyList.getBaseCurrency(),
                position: 0)
            )
        } else {
            listFromDefaults.pairs.sort(by: { $0.position < $1.position })
            
            listFromDefaults.pairs.forEach{ item in
                favoritePairList.append(CurrencyPair(
                    valueCurrency:  currencyList.getCurrency(name: item.valueName),
                    baseCurrency: currencyList.getCurrency(name: item.baseName),
                    position: item.position))
            }
        }
        //update App
        rxFavouritPairsCount.onNext(favoritePairList.count)
    }
    
    func saveCurrencyValuesToDefaults() { //Used for updating colorIndex
        //Prepare list for saving
        let list = currencyList.getFullList()
        var currencyValues: [CurrencyValuesForDefaults] = []
        var updatingDate = "Error"
        list.forEach{ currency in
            do {
                currencyValues.append(CurrencyValuesForDefaults(
                    shortName: currency.name,
                    rate: try currency.rateRx.value(),
                    previousRate: try currency.previousRateRx.value(),
                    base: currency.base,
                    colorIndex: currency.colorIndex))
            }
            //Saving with nulls
            catch {
                currencyValues.append(CurrencyValuesForDefaults(
                    shortName: currency.name,
                    rate: 0,
                    previousRate: 0,
                    base: currency.base,
                    colorIndex: currency.colorIndex))
            }
        }
        do { updatingDate = try rxUptadingDate.value() }
        catch { updatingDate = "Error" }
        
        let listForDefaults = CurrencyListForDefaults(lastUpdate: updatingDate, currencyValues: currencyValues)
        userDefaultsWorker.saveCurrencyListToDefaults(currencyList: listForDefaults)
    }
    
    func getCurrencyValuesFromDefaults() {

        let savedList = userDefaultsWorker.getCurrencyListFromDefaults()

        savedList.currencyValues.forEach{ item in
            currencyList.setCurrencyValue(
                name: item.shortName,
                value: item.rate,
                previousValue: item.previousRate,
                colorIndex: item.colorIndex)
        }
    }
    
    
}

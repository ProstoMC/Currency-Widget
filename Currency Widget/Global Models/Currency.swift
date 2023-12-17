//
//  CurrencyList.swift
//  Currency Widget
//
//  Created by macSlm on 26.10.2023.
//

import Foundation
import RxSwift

struct Currency {
    
    var rateRx: BehaviorSubject<Double>
    var previousRateRx: BehaviorSubject<Double>
    var flowRateRx: BehaviorSubject<Double>
   
    var base: String
    
    var name: String
    var shortName: String
    var logo: String
    var colorIndex: Int
    
    init(rate: Double, previousRate: Double, base: String, shortName: String) {

        self.base = base
        self.shortName = shortName
        
        self.rateRx = BehaviorSubject(value: rate)
        self.previousRateRx = BehaviorSubject(value: previousRate)
        self.flowRateRx = BehaviorSubject(value: 0)
        self.colorIndex = 0
 
        //Set apperance
        switch shortName {
        case "RUB":
            name = "Russian Ruble"
            logo = "₽"
        case "AUD":
            name = "Australian Dollar"
            logo = "A$"
        case "AZN":
            name = "Azerbaijani Manat"
            logo = "₼"
        case "GBP":
            name = "British Pound Sterling"
            logo = "£"
        case "AMD":
            name = "Armenian Dram"
            logo = "֏"
        case "BYN":
            name = "Belarusian Ruble"
            logo = "Br"
        case "BGN":
            name = "Bulgarian Lev"
            logo = "лв"
        case "BRL":
            name = "Brazilian Real"
            logo = "R$"
        case "HUF":
            name = "Hungarian Forint"
            logo = "Ft"
        case "VND":
            name = "Vietnamese Dong"
            logo = "₫"
        case "HKD":
            name = "Hong Kong Dollar"
            logo = "₫"
        case "GEL":
            name = "Georgian Lari"
            logo = "₾"
        case "DKK":
            name = "Danish Krone"
            logo = "kr"
        case "AED":
            name = "UAE Dirham"
            logo = "د.إ"
        case "USD":
            name = "United States Dollar"
            logo = "$"
        case "EUR":
            name = "Euro"
            logo = "€"
        case "EGP":
            name = "Egyptian Pound"
            logo = "E£"
        case "INR":
            name = "Indian Rupee"
            logo = "₹"
        case "IDR":
            name = "Indonesian Rupiah"
            logo = "Rp"
        case "KZT":
            name = "Kazakhstani Tenge"
            logo = "₸"
        case "CAD":
            name = "Canadian Dollar"
            logo = "$"
        case "QAR":
            name = "Qatari Rial"
            logo = "﷼"
        case "KGS":
            name = "Kyrgystani Som"
            logo = "лв"
        case "CNY":
            name = "Chinese Yuan"
            logo = "¥"
        case "MDL":
            name = "Moldovan leu"
            logo = "L"
        case "NZD":
            name = "New Zealand Dollar"
            logo = "NZ$"
        case "NOK":
            name = "Norwegian Krone"
            logo = "kr"
        case "PLN":
            name = "Polish Zloty"
            logo = "zł"
        case "RON":
            name = "Romanian Leu"
            logo = "RON"
        case "XDR":
            name = "Special Drawing Rights"
            logo = "XDR"
        case "SGD":
            name = "Singapore dollar"
            logo = "S$"
        case "TJS":
            name = "Tajikistani somoni"
            logo = "TJS"
        case "THB":
            name = "Thai baht"
            logo = "฿"
        case "TRY":
            name = "Turkish Lira"
            logo = "₺"
        case "TMT":
            name = "Turkmenistani Manat"
            logo = "T"
        case "UZS":
            name = "Uzbekistan Som"
            logo = "лв"
        case "UAH":
            name = "Ukranian Hryvnia"
            logo = "₴"
        case "CZK":
            name = "Czech Koruna"
            logo = "Kč"
        case "SEK":
            name = "Swedish Krona"
            logo = "kr"
        case "CHF":
            name = "Swiss Franc"
            logo = "₣"
        case "RSD":
            name = "Serbian Dinar"
            logo = "РСД"
        case "ZAR":
            name = "South African Rand"
            logo = "R"
        case "KRW":
            name = "Korean Won"
            logo = "₩"
        case "JPY":
            name = "Japanese Yen"
            logo = "¥"
        default:
            name = "Currency"
            logo = "\u{00A4}"
        }

    }
}



//
//  CurrencyUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/24/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

protocol CurrencyUseCaseDelegate {
    func responseData(resultModel: ResultData)
}

class CurrencyUseCase {
    var rateData: CurrencyData?
    var delegate: CurrencyUseCaseDelegate?
}

extension CurrencyUseCase {
    // MARK: - Get data from API with desired currencies, base is USA
    func fetchData() {
        let url = URL(string: "https://api.currencyfreaks.com/latest?apikey=ae28c3231f23426b80da6acb5bc27c63&symbols=VND,EUR,JPY,KRW,CNY,SGD,AUD,CAD")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let rateData = data {
                    let decodedData = try JSONDecoder().decode(CurrencyData.self, from: rateData)
                    DispatchQueue.main.sync {
                        self.rateData = decodedData
                    }
                } else {
                    return
                }
            } catch {
                return
            }
        }.resume()
    }
     
    // MARK: - Perform logic to transfer base from USA back to VND, return result of other currencies
    func exchangeVNDToOtherCurrencies(_ amount: Double) {
        var result: ResultData = ResultData(USD: 0.0, EUR: 0.0, JPY: 0.0, KRW: 0.0, CNY: 0.0, SGD: 0.0, AUD: 0.0, CAD: 0.0)
        
        result.USD = (amount / Double(self.rateData?.rates.VND ?? "")!)
        result.USD = result.USD.roundTo(places: 2)
        
        result.EUR = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.EUR ?? "")!)
        result.JPY = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.JPY ?? "")!)
        result.KRW = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.KRW ?? "")!)
        result.CNY = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.CNY ?? "")!)
        result.SGD = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.SGD ?? "")!)
        result.AUD = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.AUD ?? "")!)
        result.CAD = exchangeMiddleware(sourceRate: result.USD, exchangeRate: Double(self.rateData?.rates.CAD ?? "")!)
        
        delegate?.responseData(resultModel: result)
    }
    
    // MARK: - Middleware to exchange USD to other currencies
    func exchangeMiddleware(sourceRate: Double, exchangeRate: Double) -> Double {
        return (sourceRate * exchangeRate).roundTo(places: 2)
    }
}

// MARK: - Rounding doubles to specific decimal places
extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

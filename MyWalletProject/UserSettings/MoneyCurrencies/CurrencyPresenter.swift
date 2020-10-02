//
//  CurrencyPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/24/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol CurrencyPresenterProtocol {
    func receiveExchangeResult(resultModel: ResultData)
}

class CurrencyPresenter {
    
    var viewDelegate: CurrencyViewControllerProtocol?
    var usecase: CurrencyUseCase = CurrencyUseCase()
    
    func fetchData() {
        usecase.presenterDelegate = self
        //show loading
        usecase.fetchData()
    }
    
    func exchangeCurrency(amount: Double) {
        usecase.presenterDelegate = self
        usecase.exchangeVNDToOtherCurrencies(amount)
    }
}

extension CurrencyPresenter: CurrencyPresenterProtocol {
    func receiveExchangeResult(resultModel: ResultData) {
        viewDelegate?.setupForView(resultModel: resultModel)
    }
}

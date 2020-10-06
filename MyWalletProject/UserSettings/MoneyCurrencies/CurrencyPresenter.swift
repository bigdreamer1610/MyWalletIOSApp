//
//  CurrencyPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/24/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol CurrencyPresenterDelegate {
    func setupForViews(resultModel: ResultData)
}

class CurrencyPresenter {
    
    var delegate: CurrencyPresenterDelegate?
    var usecase: CurrencyUseCase?
    
    init(delegate: CurrencyPresenterDelegate, usecase: CurrencyUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }

    func fetchData() {
        usecase?.fetchData()
    }
    
    func exchangeCurrency(amount: Double) {
        usecase?.exchangeVNDToOtherCurrencies(amount)
    }
}

extension CurrencyPresenter: CurrencyUseCaseDelegate {
    func responseData(resultModel: ResultData) {
        delegate?.setupForViews(resultModel: resultModel)
    }
}

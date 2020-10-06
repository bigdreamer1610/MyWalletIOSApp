//
//  TransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol TransactionPresenterDelegate: class {
    func getNumberOfCategory(number: Int)
}

class TransactionPresenter {
    weak var delegate: TransactionPresenterDelegate?
    fileprivate var transactionUseCase: TransactionUseCase?
    
    init(delegate: TransactionPresenterDelegate, usecase: TransactionUseCase) {
        self.delegate = delegate
        self.transactionUseCase = usecase
        self.transactionUseCase?.delegate = self
    }
    
    func responseDataCategory(){
        // process data
        transactionUseCase?.getDataFromFirebase()
    }
}

extension TransactionPresenter: TransactionUseCaseDelegate {
    func responseData(cate: [Category]) {
        //data here
        //reload data
        delegate?.getNumberOfCategory(number: cate.count)
    }
}

//
//  DetailTransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol DetailTransactionPresenterDelegate: class {
    func getEvent(event: Event)
}
class DetailTransactionPresenter {
    weak var delegate: DetailTransactionPresenterDelegate?
    fileprivate var usecase: DetailTransactionUseCase?
    
    init(delegate: DetailTransactionPresenterDelegate, usecase: DetailTransactionUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
    
    func getInfo(id: String){
        usecase?.getEventInfo(eventid: id)
    }
}

extension DetailTransactionPresenter : DetailTransactionUseCaseDelegate{
    func responseEvent(event: Event) {
        print("this event: \(event)")
        delegate?.getEvent(event: event)
    }
    
    
}

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
    func getTransaction(transaction: Transaction)
    func getCategory(cate: Category)
    func noEvent()
}
class DetailTransactionPresenter {
    weak var delegate: DetailTransactionPresenterDelegate?
    fileprivate var usecase: DetailTransactionUseCase?
    fileprivate var trans: Transaction?
    
    init(delegate: DetailTransactionPresenterDelegate, usecase: DetailTransactionUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
    
    func getInfo(id: String){
        usecase?.getEventInfo(eventid: id)
    }
    
    func fetchTransaction(id: String){
        usecase?.getTransaction(transid: id)
    }
    
    func deleteTransaction(t: Transaction){
        usecase?.deleteTransaction(t: t)
    }
}

extension DetailTransactionPresenter : DetailTransactionUseCaseDelegate{
    func responseCategory(cate: Category) {
        //after receive category
        delegate?.getCategory(cate: cate)
    }
    
    func responseEvent(event: Event) {
        delegate?.getEvent(event: event)
    }
    
    func responseTrans(trans: Transaction) {
        usecase?.getCategory(cid: trans.categoryid!)
        usecase?.getEventInfo(eventid: trans.eventid ?? "")
        self.trans = trans
        delegate?.getTransaction(transaction: trans)
    }
    
    func responseNoEvent() {
        delegate?.noEvent()
    }
    
    
}

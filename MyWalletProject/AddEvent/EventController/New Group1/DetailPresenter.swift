//
//  DetailPresenter.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
protocol DetailPresenterDelegate: class {
    func responData(number: String)
    func responEvent(event: Event)
}

class DetailPresenter {
    weak var delegate: DetailPresenterDelegate?
    fileprivate var detailEventUseCase: DetailEventUseCase?
    var checkDate = CheckDate()

    init( delegate: DetailPresenterDelegate, useCase: DetailEventUseCase) {
        self.delegate = delegate
        self.detailEventUseCase = useCase
        self.detailEventUseCase?.delegate = self
    }
    //Xoa Event
    func responseDataEvent(event: Event) {
        detailEventUseCase?.deleteData(event: event)
        detailEventUseCase?.deleteEventInTransaction(event: event)
    }
    
    // Danh dau hoan tat
    func markedComple(event: Event) {
        detailEventUseCase?.marKedCompele(event: event)
    }
    // Danh dau chua hoan tat
    func incompleteMarkup(event: Event)  {
        detailEventUseCase?.incompleteMarkup(event: event)
    }
    
    // Dem ngay
    func still(event: Event)  {
           delegate?.responData(number: checkDate.stillDate(endDate: event.date!))
    }
    
    //Gêtvent
    func getEvent(event: Event)  {
        detailEventUseCase?.getData(event: event)
    }
}
extension DetailPresenter: DetailEventUseCaseDelegate{
    func resultEvent(event: Event) {
        delegate?.responEvent(event: event)
    }
    
    func marKedCompeleEvent(event: Event) {
        
    }
    
    
}

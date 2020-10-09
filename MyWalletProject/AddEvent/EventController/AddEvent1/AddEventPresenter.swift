//
//  AddEventPresenter.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol AddEventPresenterDelegate: class {
    func data( event : Event)
}

class AddEventPresenter: AddEventTableUseCaseDelegate {
    
    weak var delegate: AddEventPresenterDelegate?
       fileprivate var addEventTavbleUseCase: AddEventTableUseCase?
    
    func editEvent(event: Event) {
        delegate?.data(event: event)
    }
    
    init(delegate: AddEventPresenterDelegate, userCase: AddEventTableUseCase) {
        self.delegate = delegate
        self.addEventTavbleUseCase = userCase
        self.addEventTavbleUseCase?.delegate = self
    }
    
    func addDataEvent(event: Event, state: Int)  {
        addEventTavbleUseCase?.addData(event: event, state: state)
    }
    
    func alertController()  {
        
    }

    
}


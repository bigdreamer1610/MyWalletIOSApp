//
//  EventPresenter.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol EventPresenterDelegate: class {
    func getDataEvent(arrEvent: [Event], arrNameEvent: [String])
}

class EventPresenter {
    
    weak var delegate: EventPresenterDelegate?
    fileprivate var eventUseCase: EventUseCase?
    
    
    init(delegate: EventPresenterDelegate, usecase: EventUseCase) {
        self.delegate = delegate
        self.eventUseCase = usecase
        self.eventUseCase?.delegate = self
    }
    
    // getdata
    func fetchDataApplying() {
       // eventUseCase?.refresh()
        eventUseCase?.getCurrenlyApplying1()
    }
    
    func fetchDataFinished()  {
        eventUseCase?.getEventFinished()
    }
    func pushVIew()  {  
    }
}

extension EventPresenter: EventUseCaseDelegate{
    func getData(arrEvent: [Event], arrNameEvent: [String]) {
        delegate?.getDataEvent(arrEvent: arrEvent, arrNameEvent: arrNameEvent)
    }
    
    
}

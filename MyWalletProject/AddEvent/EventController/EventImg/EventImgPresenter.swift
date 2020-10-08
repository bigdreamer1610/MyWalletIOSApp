//
//  EventImgPresenter.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol EventImgPresenterDelegate: class {
    func getNumberOfEventImg(imgs : [String])
}

class EventImgPresenter {
    weak var delegate: EventImgPresenterDelegate?
    fileprivate var eventUseCase: EventImgUseCase?
    
    init(delegate: EventImgPresenterDelegate, usecase: EventImgUseCase) {
        self.delegate = delegate
        self.eventUseCase = usecase
        self.eventUseCase?.delegate = self
    }
    //Get data
    func fetchData1()  {
        eventUseCase?.fetchData()
    }
    
}

extension EventImgPresenter: EventImgUseCaseDelegate{
    func data( imgEvents: [String]) {
        
        delegate?.getNumberOfEventImg(imgs: imgEvents)
    }
    
    
}

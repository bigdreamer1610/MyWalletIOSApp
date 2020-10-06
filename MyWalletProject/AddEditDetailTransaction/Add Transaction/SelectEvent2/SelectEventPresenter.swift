//
//  SelectEventPresenter.swift
//  MyWalletProject
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
protocol SelectEventPresenterDelegate: class  {
    func getDataOfEvent(data: [Event])
    func reloadData()
}

class SelectEventPresenter {
    var events  = [Event]()
    var delegate: SelectEventPresenterDelegate?
    var selectEventUserCase: SelectEventUserCase?
    
    init(delegate: SelectEventPresenterDelegate, usecase: SelectEventUserCase ) {
        self.delegate = delegate
        self.selectEventUserCase = usecase
        self.selectEventUserCase?.delegate = self
    }
    
    func responseDataEvent(){
        selectEventUserCase?.getDataFromFirebase()
    }
}

extension SelectEventPresenter: SelectEventUserCaseDelegate {
    func responseData(data: [Event]) {
        self.events = data
        delegate?.reloadData()
        delegate?.getDataOfEvent(data: data)
    }
    
    
}

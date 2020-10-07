//
//  SelectIconPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol SelectIconPresenterDelegate {
    func getDataForView(_ imageName: [String])
}

class SelectIconPresenter {
    var delegate: SelectIconPresenterDelegate?
    var usecase: SelectIconUseCase?
    
    init(delegate: SelectIconPresenterDelegate, usecase: SelectIconUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
}

extension SelectIconPresenter {
    func requestListImage() {
        usecase?.getListImageFromDB()
    }
}

extension SelectIconPresenter: SelectIconUseCaseDelegate {
    func responseListImage(_ imageName: [String]) {
        delegate?.getDataForView(imageName)
    }
}

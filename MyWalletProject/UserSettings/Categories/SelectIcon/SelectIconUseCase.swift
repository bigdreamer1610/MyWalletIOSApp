//
//  SelectIconUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol SelectIconUseCaseDelegate {
    func responseListImage(_ imageName: [String])
}

class SelectIconUseCase {
    var delegate: SelectIconUseCaseDelegate?
}

extension SelectIconUseCase {
    func getListImageFromDB() {
        
    }
}

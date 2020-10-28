//
//  ViewTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/2/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CodableFirebase
import RxSwift

protocol ViewTransactionUseCaseDelegate: BaseUseCaseDelegate {
    func responseBalance(balance: Int)
    func responseAllTransactions(trans: [Transaction])
}

class ViewTransactionUseCase : BaseUseCase {
    weak var delegate: ViewTransactionUseCaseDelegate?
}

extension ViewTransactionUseCase {
    
    func getListCategories(){
        getListAllCategories { [weak self](categories) in
            guard let `self` = self else {return}
            self.delegate?.responseDataCategories(cate: categories)
        }
    }
    
    func getBalance(){
        Defined.ref.child(Path.balance.getPath()).observe(.value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.delegate?.responseBalance(balance: value)
            }
        }
    }
    
    func getAllTransactions(){
        getListAllTransactions { [weak self](allTransactions) in
            guard let `self` = self else {return}
            self.delegate?.responseAllTransactions(trans: allTransactions)
        }
    }
    
}



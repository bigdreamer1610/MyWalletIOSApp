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
import RxCocoa

protocol ViewTransactionUseCaseDelegate: class{
    func responseBalance(balance: Int)
}

class ViewTransactionUseCase : BaseUseCase {
    weak var delegate: ViewTransactionUseCaseDelegate?
    public let cateSubject = PublishSubject<[Category]>()
    public let tranSubject = PublishSubject<[Transaction]>()
    public let balanceSubject = BehaviorRelay(value: 0)
}

extension ViewTransactionUseCase {
    
    //RxSwift
    func getCategorySingle() -> Single<[Category]>{
        return Single<[Category]>.create { (single) in
            self.getListCateSingle { [weak self] (success, cate, error) in
                guard let _ = self else {return}
                if success, let cate = cate {
                    single(.success(cate))
                } else {
                    single(.failure(error as! Error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTransactionsSingle() -> Single<[Transaction]>{
        return Single<[Transaction]>.create { (single) in
            self.getListTransSingle { [weak self](success, trans, error) in
                guard let _ = self else {return}
                if success, let trans = trans {
                    single(.success(trans))
                } else {
                    single(.failure(error as! Error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getListCategories(){
        getListAllCategories { [weak self](categories) in
            guard let `self` = self else {return}
            self.cateSubject.onNext(categories)
        }
    }
    func getBalance(){
        Defined.ref.child(Path.balance.getPath()).observe(.value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.balanceSubject.accept(value)
            }
        }
    }
    
    func getAllTransactions(){
        getListAllTransactions { [weak self](allTransactions) in
            guard let `self` = self else {return}
            self.tranSubject.onNext(allTransactions)
        }
    }
    
}



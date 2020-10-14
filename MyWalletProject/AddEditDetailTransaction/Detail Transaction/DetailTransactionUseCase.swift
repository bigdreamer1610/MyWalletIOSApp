//
//  DetailTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

protocol DetailTransactionUseCaseDelegate: class {
    func responseEvent(event: Event)
    func responseTrans(trans: Transaction)
    func responseCategory(cate: Category)
    func responseNoEvent()
}
class DetailTransactionUseCase{
    weak var delegate: DetailTransactionUseCaseDelegate?
}

extension DetailTransactionUseCase {
    func getEventInfo(eventid: String){
        if eventid != "" {
            Defined.ref.child(FirebasePath.event).observe(DataEventType.value) { [weak self](snapshot) in
                guard let `self` = self else {return}
                for case let snapshots as DataSnapshot in snapshot.children {
                    guard let dict = snapshots.value as? [String:Any] else {
                        return
                    }
                    do {
                        let model = try FirebaseDecoder().decode(Event.self, from: dict)
                        if model.id == eventid {
                            self.delegate?.responseEvent(event: model)
                            print("found event: \(eventid)")
                            break
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        } else {
            delegate?.responseNoEvent()
        }
        
    }
    
    func deleteTransaction(t: Transaction){
        Defined.ref.child(FirebasePath.transaction).child("/\(t.transactionType!)/\(t.id!)").removeValue { (error, reference) in
            //remove old position
        }
    }
    
    func getTransaction(transid: String){Defined.ref.child(FirebasePath.transaction).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    do {
                        var model = try FirebaseDecoder().decode(Transaction.self, from: dict)
                        model.id = snapshot.key
                        model.transactionType = snapshots.key
                        if model.id == transid {
                            self.delegate?.responseTrans(trans: model)
                            print("my model: \(model)")
                            break
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getCategory(cid: String){
        Defined.ref.child(FirebasePath.category).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String:Any] else {
                        return
                    }
                    do {
                        var model = try FirebaseDecoder().decode(Category.self, from: dict)
                        model.transactionType = snapshots.key
                        model.id = snapshot.key
                        if model.id == cid {
                            self.delegate?.responseCategory(cate: model)
                            break
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }
}

//
//  TransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol TransactionUseCaseDelegate: class {
    func responseData(cate : [Category])
}

class TransactionUseCase {
    weak var delegate: TransactionUseCaseDelegate?
}

extension TransactionUseCase {
    func getDataFromFirebase() {
        //get data category
        var categories = [Category]()
        Defined.ref.child("Category").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //expense/income
                for mySnap in snapshots {
                    let myKey = (mySnap as AnyObject).key as String
                    //key inside expense/income
                    if let mySnap = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in mySnap {
                            let id = snap.key
                            if let value = snap.value as? [String: Any]{
                                let name = value["name"] as? String
                                let iconImage = value["iconImage"] as? String
                                let transactionType =  myKey
                                let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                                categories.append(category)
                            }
                        }
                        
                    }
                }
                self.delegate?.responseData(cate: categories)
            }
        }
    }
    
    
}


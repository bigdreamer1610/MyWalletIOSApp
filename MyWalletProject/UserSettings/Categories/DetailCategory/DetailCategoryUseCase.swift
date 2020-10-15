//
//  DetailCategoryUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DetailCategoryUseCase {
    
}

extension DetailCategoryUseCase {
    func deleteCategoryInDB(_ category: Category) {
        var categoryIdDB = ""
        var categoryTypeDB = ""
        
        if let categoryId = category.id {
            categoryIdDB = categoryId
        }
        if let categoryType = category.transactionType {
            categoryTypeDB = categoryType
        }
        
        Defined.ref.child(Path.category.getPath()).child(categoryTypeDB).child(categoryIdDB).removeValue()
    }
    
    func deleteAllTransactionOfCategoryInDB(_ category: Category) {
        Defined.ref.child(Path.transaction.getPath()).child("\(category.transactionType ?? "")").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard self != nil else {
                return
            }
            if let dataSnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for dataSnap in dataSnapshots {
                    let id = dataSnap.key
                    if let value = dataSnap.value as? [String:Any] {
                        let categoryId = value["categoryid"] as? String
                        if (categoryId ?? "") == (category.id ?? "") {
                            Defined.ref.child("\(Path.transaction.getPath())/\(category.transactionType ?? "")/\(id)").removeValue {(error, ref) in}
                        }
                    }
                }
            }
        }
    }
    
    func deleteAllBudgetOfCategoryInDB(_ category: Category) {
        Defined.ref.child(Path.budget.getPath()).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard self != nil else {
                return
            }
            if let dataSnapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for dataSnap in dataSnapshots {
                    let id = dataSnap.key
                    if let value = dataSnap.value as? [String:Any] {
                        let categoryId = value["categoryId"] as? String
                        if (categoryId ?? "") == (category.id ?? "") {
                            Defined.ref.child("\(Path.budget.getPath())/\(id)").removeValue {(error, ref) in}
                        }
                    }
                }
            }
        }
    }
}


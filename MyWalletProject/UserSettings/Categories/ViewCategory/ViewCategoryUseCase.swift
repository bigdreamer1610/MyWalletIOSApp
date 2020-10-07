//
//  ViewCategoryUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ViewCategoryUseCaseDelegate {
    func responseListCategoryIncome(_ listCategoryIncome: [Category])
    func responseListCategoryExpense(_ listCategoryExpense: [Category])
}

class ViewCategoryUseCase {
    var delegate: ViewCategoryUseCaseDelegate?
    
    var categoriesIncome: [Category] = []
    var categoriesExpense: [Category] = []
}

extension ViewCategoryUseCase {
    func getExpenseCategories() {
        categoriesExpense.removeAll()
        
        Defined.ref.child("Category").child("expense").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let imgName = dict["iconImage"] as? String
                let nameCate = dict["name"] as? String
                
                let cate = Category(id: categoryId, name: nameCate, transactionType: "expense", iconImage: imgName)
                self.categoriesExpense.append(cate)
            }
            
            self.delegate?.responseListCategoryExpense(self.categoriesExpense)
        }
    }
    
    func getIncomeCategories() {
        categoriesIncome.removeAll()
        
        Defined.ref.child("Category").child("income").observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let imgName = dict["iconImage"] as? String
                let nameCate = dict["name"] as? String
                
                let cate = Category(id: categoryId, name: nameCate, transactionType: "expense", iconImage: imgName)
                self.categoriesIncome.append(cate)
            }
            
            self.delegate?.responseListCategoryIncome(self.categoriesIncome)
        }
    }
}

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
    func reponseListImage(_ listImage: [String])
}

class ViewCategoryUseCase {
    var delegate: ViewCategoryUseCaseDelegate?
    
    var categoriesIncome: [Category] = []
    var categoriesExpense: [Category] = []
    var listImage: [String] = []
}

extension ViewCategoryUseCase {
    func getListImage() {
        listImage.removeAll()
        
        Defined.ref.child(FirebasePath.imagelibrary).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                
                if let imgName = dict["iconImage"] as? String {
                    self.listImage.append(imgName)
                } else {
                    return
                }
            }
            
            self.delegate?.reponseListImage(self.listImage)
        }
    }
    
    func getExpenseCategories() {
        categoriesExpense.removeAll()
        
        Defined.ref.child(FirebasePath.cateExpense).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
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
        
        Defined.ref.child(FirebasePath.cateIncome).observeSingleEvent(of: .value) { snapshot in
            for case let child as DataSnapshot in snapshot.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
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

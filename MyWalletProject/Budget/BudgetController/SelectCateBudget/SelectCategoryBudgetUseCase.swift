//
//  SelectCategoryBudgetUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

protocol SelectCategoryBudgetUseCaseDelegate : class {
    func getDataCate(listCateExpense:[Category], listCateIncome:[Category])
}

class SelectCategoryBudgetUseCase {
    weak var delegate : SelectCategoryBudgetUseCaseDelegate?
}

extension SelectCategoryBudgetUseCase {
    func getDataCategoryDB(){
        var listCateExpense = [Category]()
        var listCateIncome = [Category]()

        let dispatchGroup = DispatchGroup() // tạo luồng load cùng 1 nhóm
        
        // load api Category Expense
        dispatchGroup.enter()
        Defined.ref.child(Path.category.getPath()).child("expense").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
                    return
                }
                let imgName = dict["iconImage"] as? String
                let nameCate = dict["name"] as? String
                let cate = Category(id: categoryId, name: nameCate, transactionType: "expense", iconImage: imgName)
                listCateExpense.append(cate)
            }
            dispatchGroup.leave()
        }
        
        // Load api Category Income
        dispatchGroup.enter()
        Defined.ref.child(Path.category.getPath()).child("income").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                let categoryId = child.key
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let imgName = dict["iconImage"] as? String
                let nameCate = dict["name"] as? String
                let cate = Category(id: categoryId, name: nameCate, transactionType: "expense", iconImage: imgName)
                listCateIncome.append(cate)
            }
            dispatchGroup.leave()
        }
        
        // Sau khi load hết api mới reload lại table
        dispatchGroup.notify(queue: .main, execute: {
            self.delegate?.getDataCate(listCateExpense: listCateExpense, listCateIncome: listCateIncome)
        })
    }
}


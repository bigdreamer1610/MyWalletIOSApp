//
//  BudgetDetailUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

class BudgetDetailUseCase {
    
    func deleteBudgetDB1(id:Int){
        Defined.ref.child("Account").child("userid1").child("budget").child("\(id)").removeValue()
    }
}


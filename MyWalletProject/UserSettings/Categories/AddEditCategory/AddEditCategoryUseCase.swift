//
//  AddEditCategoryUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class AddEditCategoryUseCase {
    
}

extension AddEditCategoryUseCase {
    func saveUserCategoryToDB(_ category: Category, _ categoryType: String) {
        let userCategory = [
            "iconImage": category.iconImage ?? "",
            "name": category.name ?? ""] as [String : Any]
        
        Defined.ref.child("Category").child(categoryType).child(category.id ?? "").setValue(userCategory, withCompletionBlock: {
            error, ref in
            if error == nil {}
            else {}
        })
    }
}

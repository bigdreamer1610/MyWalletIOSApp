//
//  DetailCategoryUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

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
        
        Defined.ref.child("Category").child(categoryTypeDB).child(categoryIdDB).removeValue()
    }
}

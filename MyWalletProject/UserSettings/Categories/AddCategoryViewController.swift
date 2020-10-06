//
//  AddCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
    }
    
    // MARK: - Hide tab bar
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }

    @IBAction func btnCancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
    }
}

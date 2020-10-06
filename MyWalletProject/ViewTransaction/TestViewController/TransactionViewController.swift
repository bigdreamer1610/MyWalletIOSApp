//
//  TransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol TransactionViewControllerProtocol {
    func setLabel()
}

class TransactionViewController: UIViewController {

    
    @IBOutlet var lbNumber: UILabel!
    var number: Int = 0
    var presenter: TransactionPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.responseDataCategory()
        // Do any additional setup after loading the view.
    }
    
    
    func setUp(presenter: TransactionPresenter){
        self.presenter = presenter
    }
}

extension TransactionViewController : TransactionPresenterDelegate {
    func getNumberOfCategory(number: Int) {
        self.number = number
        // number here
        lbNumber.text = "\(number)"
    }
    
    
}

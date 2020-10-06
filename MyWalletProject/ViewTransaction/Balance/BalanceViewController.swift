//
//  BalanceViewController.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    var presenter: BalancePresenter?
    @IBOutlet var txtAmount: UITextField!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnSave: UIBarButtonItem!
    var balance = Defined.defaults.integer(forKey: Constants.balance)
    private var formatter = NumberFormatter()
    
    override func viewDidLoad() {
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        super.viewDidLoad()
        txtAmount.delegate = self
        initData()
        
    }
    
    func setUp(presenter: BalancePresenter){
        self.presenter = presenter
    }
    
    func initData(){
        txtAmount.text = "\(formatter.string(from: NSNumber(value: balance))!)"
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if let balanceStr = txtAmount.text,
            let balanceInt = Int(balanceStr){
            presenter?.updateBalance(with: balanceInt)
            AppRouter.routerTo(from: RouterType.tabbar.getVc(), options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
        }
        
    }
    @IBAction func clickCancel(_ sender: Any) {
        AppRouter.routerTo(from: RouterType.tabbar.getVc(), options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
    }
}

extension BalanceViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //only text num
        let allowCharacters = "0123456789"
        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
        let typeCharacterSet = CharacterSet(charactersIn: string)
        return allowCharacterSet.isSuperset(of: typeCharacterSet)
    }
}

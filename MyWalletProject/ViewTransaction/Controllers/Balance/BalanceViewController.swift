//
//  BalanceViewController.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    
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
        txtAmount.text = "\(formatter.string(from: NSNumber(value: balance))!)"
    }
    
    
    @IBAction func clickSave(_ sender: Any) {
        if let balanceStr = txtAmount.text,
            let balancInt = Int(balanceStr){
            Defined.defaults.set(balancInt, forKey: Constants.balance)
            balance = balancInt
            Defined.ref.child("Account/userid1/information").updateChildValues(["balance": balancInt]){ (error,reference) in
                
            }
        }
        let vc = RouterType.tabbar.getVc()
        AppRouter.routerTo(from: vc, options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
    }
    @IBAction func clickCancel(_ sender: Any) {
        let vc = RouterType.tabbar.getVc()
        AppRouter.routerTo(from: vc, options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
        
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

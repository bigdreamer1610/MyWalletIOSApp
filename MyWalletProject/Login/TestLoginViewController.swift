//
//  TestLoginViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class TestLoginViewController: UIViewController {

    @IBOutlet weak var lblid: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    let id = UserDefaults.standard.value(forKey: "idUser") as! String
    let name = UserDefaults.standard.value(forKey: "nameUser") as! String
    let email = UserDefaults.standard.value(forKey: "emailUser") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblid.text = id
        lblname.text = name
        lblemail.text = email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Do you want exit", message: nil, preferredStyle: .alert)
        
         let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
                UserDefaults.standard.set(false,forKey: "login")
                UserDefaults.standard.removeObject(forKey: "nameUser")
                UserDefaults.standard.removeObject(forKey: "idUser")
                UserDefaults.standard.removeObject(forKey: "emailUser")
                let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(vc, animated: true)
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

//
//  SettingsViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtBalance: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLanguage: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRoundedImage()
        configureButton(btnSave)
        configureButton(btnCancel)
    }
    
    // MARK: - Rounded user's avatar
    func makeRoundedImage() {
        avaImage.layer.borderWidth = 1
        avaImage.layer.masksToBounds = false
        avaImage.layer.backgroundColor = UIColor.systemPink.cgColor
        avaImage.layer.cornerRadius = avaImage.frame.height / 2
        avaImage.clipsToBounds = true
    }
    
    // MARK: - Make rounded buttons
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
    }
}

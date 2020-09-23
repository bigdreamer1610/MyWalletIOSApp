//
//  UserSettingsViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
    
    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var btnSignOut: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeRoundedImage()
        configureButton(btnSignOut)
        tableViewConfiguration()
    }
    
    // MARK: - Config and regist for tableView
    func tableViewConfiguration() {
        tableView.register(SettingsItemViewCell.nib(), forCellReuseIdentifier: SettingsItemViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
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
    
    @IBAction func btnSignOutClicked(_ sender: Any) {
        // TODO: - Implementation of signing out action
    }
}

extension UserSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemViewCell.identifier, for: indexPath) as! SettingsItemViewCell
        
        var imageName = ""
        var labelName = ""
        if indexPath.row == 0 {
            imageName = "s-settings"
            labelName = "Settings"
        } else if indexPath.row == 1 {
            imageName = "s-categories"
            labelName = "Categories"
        } else {
            imageName = "Undefined"
            labelName = "Undefined"
        }
        
        cell.setupView(imageName, labelName)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

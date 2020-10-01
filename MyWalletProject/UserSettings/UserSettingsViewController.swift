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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings and Tools"
        
        tableViewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    // MARK: - Config and regist for tableView
    func tableViewConfiguration() {
        tableView.register(SettingsItemViewCell.nib(), forCellReuseIdentifier: SettingsItemViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
    }
}

extension UserSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemViewCell.identifier, for: indexPath) as! SettingsItemViewCell
        
        var imageName = ""
        var labelName = ""
        
        switch indexPath.row {
        case 0:
            imageName = "s-settings"
            labelName = "Settings"
        case 1:
            imageName = "s-categories"
            labelName = "Categories"
        case 2:
            imageName = "s-currencies"
            labelName = "Money Currencies"
        default:
            imageName = "Undefined"
            labelName = "Undefined"
        }
        
        cell.setupView(imageName, labelName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let settingsController = UIStoryboard.init(name: "UserSettings", bundle: nil).instantiateViewController(identifier: "settingsVC") as! SettingsViewController
            navigationController?.pushViewController(settingsController, animated: true)
        case 1:
            // TO DO: - Implementation of Categories Screen
//            let settingsController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "settings")
//            navigationController?.pushViewController(settingsController, animated: true)
            print("For categories")
        case 2:
            let currencyController = UIStoryboard.init(name: "UserSettings", bundle: nil).instantiateViewController(identifier: "currencyVC") as! CurrencyViewController
            currencyController.presenter.fetchData()
            navigationController?.pushViewController(currencyController, animated: true)
        default:
            return
        }
    }
}

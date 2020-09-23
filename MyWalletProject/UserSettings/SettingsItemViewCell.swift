//
//  SettingsItemViewCell.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class SettingsItemViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var lblItem: UILabel!
    
    static let identifier = "settingsItem"
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsItemViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(_ imageName: String, _ labelName: String) {
        iconImage.image = UIImage(named: imageName)
        lblItem.text = labelName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

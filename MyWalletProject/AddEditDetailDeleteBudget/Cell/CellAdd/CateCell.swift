//
//  CateCell.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/28/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class CateCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lblCateName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }
}

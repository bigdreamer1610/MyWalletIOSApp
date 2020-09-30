//
//  AmountCell.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/28/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
protocol AmountCellDelegete: class {
    func amoutDidChange(value: String)
}

class AmountCell: UITableViewCell {

    weak var delegate: AmountCellDelegete?

    @IBOutlet weak var lblAmount: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAmount.addTarget(self, action: #selector(aaaaa), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func txtAmountChange(_ sender: UITextField) {
    }
    
    @objc func aaaaa() {
        if let value = lblAmount.text {
            delegate?.amoutDidChange(value: value)
        }
        
    }
}

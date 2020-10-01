//
//  NameTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class NameTableViewCell: BaseTBCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    var sumIncome = 0
    var sumExpense = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if state == 1 {
//            lblName.text = "Khoản thu"
//            lblMoney.text = "\(sumIncome)"
//            lblMoney.textColor = .blue
//        } else {
//            lblName.text = "Khoản chi"
//            lblMoney.text = "\(sumExpense)"
//            lblMoney.textColor = .red
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

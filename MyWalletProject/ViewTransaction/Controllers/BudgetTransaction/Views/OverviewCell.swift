//
//  OverviewCell.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class OverviewCell: BaseTBCell {

    
    @IBOutlet var lbAmount: UILabel!
    @IBOutlet var lbType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(transactionType: String, amount: Int){
        if transactionType == TransactionType.expense.getValue(){
            lbAmount.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            lbAmount.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
        lbType.text = transactionType.capitalized
        lbAmount.text = "\(Defined.formatter.string(from: NSNumber(value: amount))!)"
    }
}

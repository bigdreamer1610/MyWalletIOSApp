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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(transactionType: String, amount: Int){
        lbType.text = transactionType.capitalized
        lbAmount.text = "\(amount)"
    }
}

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
    
    private var formatter = NumberFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // Setup label
    func setupData(_ text: String, _ color: UIColor, _ sumIncome: Int) {
        lblName.text = text
        lblMoney.textColor = color
        lblMoney.text = String(formatter.string(from: NSNumber(value: sumIncome))!)
    }
}

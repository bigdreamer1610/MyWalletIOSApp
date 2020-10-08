//
//  MoneyTableViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class MoneyTableViewCell: BaseTBCell {
    
    @IBOutlet weak var lblBeginBalance: UILabel!
    @IBOutlet weak var lblEndBalance: UILabel!
    var sumIncome = 0
    var sumExpense = 0
    private var formatter = NumberFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpData(opening: Int, ending: Int, sumIncome: Int, sumExpense: Int){
        lblBeginBalance.text = "\(formatter.string(from: NSNumber(value: opening))!)"
        lblEndBalance.text = "\(formatter.string(from: NSNumber(value: ending + sumIncome - sumExpense))!)"
    }
    
}

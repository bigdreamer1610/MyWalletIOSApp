//
//  MoneyTableViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class MoneyTableViewCell: BaseTBCell {
    
    @IBOutlet weak var lblNameOpening: UILabel!
    @IBOutlet weak var lblNameEnding: UILabel!
    @IBOutlet weak var lblBeginBalance: UILabel!
    @IBOutlet weak var lblEndBalance: UILabel!
    var sumIncome = 0
    var sumExpense = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(opening: Int, sumIncome: Int, sumExpense: Int) {
        lblBeginBalance.text = String((Defined.formatter.string(from: NSNumber(value: opening))!))
        lblEndBalance.text = String((Defined.formatter.string(from: NSNumber(value: opening + sumIncome - sumExpense))!))
    }
    
}

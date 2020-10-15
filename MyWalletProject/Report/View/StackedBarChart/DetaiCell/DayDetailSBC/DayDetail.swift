//
//  HeaderDayDetail.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DayDetail: BaseTBCell {

    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblNetIncome: UILabel!
    private var formatter = NumberFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setUpData(expense: Int, income: Int) {
        lblExpense.text = String((Defined.formatter.string(from: NSNumber(value: expense))!))
        lblIncome.text = String((Defined.formatter.string(from: NSNumber(value: income))!))
        lblNetIncome.text = String((Defined.formatter.string(from: NSNumber(value: income - expense))!))
    }
}

//
//  DayStackedBarChartTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailSBCCell: BaseTBCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblNetIncome: UILabel!
    var date = ""
    var sumIncome = 0
    var sumExpense = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(info: SumInfo) {
           lblDay.text = date
           lblIncome.text = String(sumIncome)
           lblExpense.text = String(sumExpense)
           lblNetIncome.text = String(sumIncome - sumExpense)
       }
//    func setupData(sumIncome: Int, sumExpense: Int, date: String) {
//        lblDay.text = date
//        lblIncome.text = String(sumIncome)
//        lblExpense.text = String(sumExpense)
//        lblNetIncome.text = String(sumIncome - sumExpense)
//    }
    
}

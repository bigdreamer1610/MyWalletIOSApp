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
    var netIncome = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        Defined.formatter.groupingSeparator = ","
        Defined.formatter.numberStyle = .decimal
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(info: SumInfo) {
        lblDay.text = info.date
        lblIncome.text = String((Defined.formatter.string(from: NSNumber(value: info.sumIncome))!))
        lblExpense.text = String((Defined.formatter.string(from: NSNumber(value: info.sumExpense))!))
        lblNetIncome.text = String((Defined.formatter.string(from: NSNumber(value: info.netIncome))!))
    }
}

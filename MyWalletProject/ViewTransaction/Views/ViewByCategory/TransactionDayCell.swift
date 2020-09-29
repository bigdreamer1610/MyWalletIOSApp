//
//  TransactionDayCell.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class TransactionDayCell: BaseTBCell {

    
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var lbAmount: UILabel!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbDay: UILabel!
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

    func setUpData(with data: CategoryItem){
        lbNote.text = data.note
        lbAmount.text = "\(Defined.formatter.string(from: NSNumber(value: data.amount))!)"
        lbDay.text = "\(data.dateModel.date)"
        lbDate.text = "\(data.dateModel.month) \(data.dateModel.year), \(data.dateModel.weekDay)"
        if data.type == "expense"{
            lbAmount.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            lbAmount.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
}

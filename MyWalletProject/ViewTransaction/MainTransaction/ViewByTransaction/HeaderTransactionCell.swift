//
//  HeaderTransactionCell.swift
//  SecondApp
//
//  Created by THUY Nguyen Duong Thu on 9/18/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class HeaderTransactionCell: BaseTBCell {
    
    
    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var lbLongDate: UILabel!
    @IBOutlet var lbDay: UILabel!
    @IBOutlet var lbDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        // Initialization code
    }
    
    
    func setUpData(data: TransactionHeader){
        lbDate.text = "\(data.dateModel.date)"
        lbDay.text = "\(data.dateModel.weekDay)"
        lbLongDate.text = "\(data.dateModel.year), \(data.dateModel.month)"
        lbTotal.text = "\(Defined.formatter.string(from: NSNumber(value: data.amount))!)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

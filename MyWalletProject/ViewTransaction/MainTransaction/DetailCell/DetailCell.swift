//
//  DetailCell.swift
//  SecondApp
//
//  Created by THUY Nguyen Duong Thu on 9/18/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class DetailCell: BaseTBCell {

    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var lbEnding: UILabel!
    @IBOutlet var lbOpening: UILabel!
    private var currency = "đ"
    private var formatter = NumberFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(opening: Int, ending: Int){
        lbOpening.text = "\(formatter.string(from: NSNumber(value: opening))!) \(currency)"
        lbEnding.text = "\(formatter.string(from: NSNumber(value: ending))!) \(currency)"
        lbTotal.text = "\(formatter.string(from: NSNumber(value: (ending - opening)))!) \(currency)"
    }
}

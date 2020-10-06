//
//  HeaderCategoryCell.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class HeaderCategoryCell: BaseTBCell {

    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var lbNumberOfTransactions: UILabel!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(with data: CategoryHeader){
        lbTotal.text = "\(Defined.formatter.string(from: NSNumber(value: data.amount))!)"
        lbCategory.text = "\(data.categoryName)"
        iconImage.image = UIImage(named: data.icon)
        
        lbNumberOfTransactions.text = (data.noOfTransactions <= 1) ? "\(data.noOfTransactions) transaction" : "\(data.noOfTransactions) transactions"
    }
}

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

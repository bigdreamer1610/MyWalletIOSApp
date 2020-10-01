//
//  IncomDetailTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class IncomDetailTableViewCell: BaseTBCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var lblTypeOfMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

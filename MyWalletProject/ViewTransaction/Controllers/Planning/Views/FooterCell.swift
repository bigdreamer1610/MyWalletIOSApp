//
//  FooterCell.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class FooterCell: BaseTBCell {

    
    @IBOutlet var lbDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(des: String){
        lbDescription.text = des
    }
}

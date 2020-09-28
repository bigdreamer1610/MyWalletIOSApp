//
//  TestViewCell.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/24/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class TestViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTest: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(data:Transaction){
        img.image = UIImage(named: data.categoryid ?? "")
        //lblTest.text =  String(data.amount)
        lblTest.text = data.categoryid
        
    }
    
}

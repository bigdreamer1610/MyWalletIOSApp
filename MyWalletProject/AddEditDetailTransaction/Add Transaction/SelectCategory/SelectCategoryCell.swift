//
//  SelectCategoryCell.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class SelectCategoryCell: UITableViewCell {
    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var nameCategory: UILabel!
    var type = ""
    var id = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUp(data: Category){
        id = data.id!
        type = data.transactionType!
        nameCategory.text = data.name
        imgCategory.image = UIImage(named: data.iconImage ?? "")
    }
    
}

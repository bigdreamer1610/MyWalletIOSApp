//
//  ItemPlanningCell.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ItemPlanningCell: BaseTBCell {

    
    @IBOutlet var iconArrow: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        iconArrow.setImageColor(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setUpData(item: PlanningItem){
        itemTitle.text = item.title
        itemIcon.image = UIImage(named: item.icon)
    }
    
}

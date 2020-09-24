//
//  CategoryEventCell.swift
//  MyWallet
//
//  Created by Van Thanh on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class CategoryEventCell: UICollectionViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func load(iconImg: String)  {
        self.imgCategory.image = UIImage(named: iconImg)
    }

}

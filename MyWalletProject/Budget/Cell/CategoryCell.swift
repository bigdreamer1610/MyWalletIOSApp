//
//  CategoryCell.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lblCate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadContent(imgName:String , categoryName:String , language:String){
        imgCate.image = UIImage.init(named: imgName)
        lblCate.text = categoryName.addLocalizableString(str: language)
    }
    
}


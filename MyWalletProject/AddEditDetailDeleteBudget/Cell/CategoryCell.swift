//
//  CategoryCell.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
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
    
    func loadContent(imgName:String , categoryName:String){
        imgCate.image = UIImage.init(named: imgName)
        lblCate.text = categoryName
    }
    
}

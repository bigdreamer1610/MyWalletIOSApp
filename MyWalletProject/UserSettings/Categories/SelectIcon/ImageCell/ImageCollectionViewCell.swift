//
//  ImageCollectionViewCell.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: BaseCLCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupImage(_ imageName: String) {
        categoryIcon.image = UIImage(named: imageName)
    }
}

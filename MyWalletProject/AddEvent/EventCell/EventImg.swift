//
//  EventImg.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventImg: UITableViewCell {

    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    public func load(img: String)  {
        lblEvent.text = img
        imgEvent.image = UIImage(named: img)
    }
    
}

//
//  EventCell.swift
//  MyWalletProject
//
//  Created by Van Thanh on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var spent: UILabel!
    @IBOutlet weak var nameEvent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!  
    @IBOutlet weak var lbSpent: UILabel!
    
    var format = FormatNumber()
    var checkDate = CheckDate()
    
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func load(event: Event )  {
        var so = event.spent!
        imgCategory.image = UIImage(named: event.eventImage!)
        nameEvent.text = event.name
        lbSpent.text = format.formatInt(so: so)
        so = 0
        lblDate.text = checkDate.stillDate(endDate: event.date!)
    }
    
}

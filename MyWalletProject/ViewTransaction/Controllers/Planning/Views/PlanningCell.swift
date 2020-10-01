//
//  PlanningCell.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class PlanningCell: BaseTBCell {

    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var budgetView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGestures()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addTapGestures(){
        let tapBudget = UITapGestureRecognizer(target: self, action: #selector(clickBudget))
        budgetView.addGestureRecognizer(tapBudget)
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(clickEvent))
        eventView.addGestureRecognizer(tapEvent)
    }
    
    @objc func clickBudget(){
        let vc = RouterType.budget.getVc()
        AppRouter.routerTo(from: vc, options: .curveEaseIn, duration: 0.2, isNaviHidden: false)
    }
    
    @objc func clickEvent(){
        let vc = RouterType.event.getVc()
        AppRouter.routerTo(from: vc, options: .curveEaseIn, duration: 0.2, isNaviHidden: false)
    }
    
}

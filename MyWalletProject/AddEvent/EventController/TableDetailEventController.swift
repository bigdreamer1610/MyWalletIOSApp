//
//  TableDetailEventController.swift
//  MyWalletProject
//
//  Created by Van Thanh on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class TableDetailEventController: UITableViewController {
    var delegate: TableDetailEventControllerDelegate?
    var event = Event()
    
    
    
    @IBOutlet weak var viewImg: UIView!
    
    @IBOutlet weak var lbNameEvent: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbCalendar: UILabel!
    @IBOutlet weak var btTransactionList: UIButton!
    @IBOutlet weak var btMarkedComplete: UIButton!
    
    @IBOutlet weak var imgCategory: UIImageView!
    
    @IBAction func btTransactionList(_ sender: Any) {
        print("lít")
    }
    @IBAction func btMarkedComplete(_ sender: Any) {
        print("maket")
    }
    @IBAction func btEdit(_ sender: Any) {
        let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "AddEvent") as! AddEventController
        vc.state = 0
        vc.event = self.event
        vc.completionHandler = {
            self.event = $0
        }
        vc.navigationController?.title = "Edit Event"
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btDelete(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     //  setUpView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func setUpView()  {
        viewImg.layer.cornerRadius = viewImg.frame.height / 2
        viewImg.layer.cornerRadius = viewImg.frame.width / 2
        lbNameEvent.text = event.name
        imgCategory.image = UIImage(named: event.categoryid!)
        lbMoney.text = String(event.goal!)
        lbCalendar.text = event.dateEnd
    }
}



protocol TableDetailEventControllerDelegate {
    func tappedDetail()
            
    
}

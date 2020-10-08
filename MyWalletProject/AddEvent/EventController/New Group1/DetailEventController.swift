//
//  DetailEventController.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailEventController: UITableViewController {
    
    var number = 0
    var presenter: DetailPresenter?
    var event = Event()
    var format = FormatNumber()
    var checkDate = CheckDate()
    var status = "false"
    var stillDate = 0
    // OUt let
    
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var tfNameEvent: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStillDate: UILabel!
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setUp(presenter: DetailPresenter) {
        self.presenter = presenter
    }
    
    // Chinh sua trạng thái
    @IBAction func btnMarkedComplete(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure ? ", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in   
            if self.status == "true" {
                self.presenter?.markedComple(event: self.event)
            } else{
                self.presenter?.incompleteMarkup(event: self.event)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil )
        
    }
    // Chỉnh sửa Event
    @IBAction func btnEdit(_ sender: Any) {
        let vc = UIStoryboard(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "AddEventTableController") as! AddEventTableController
        let presenter = AddEventPresenter(delegate: vc, userCase: AddEventTableUseCase())
        vc.setUp(presenter: presenter)
        vc.state = 1
        vc.event = self.event
        vc.title = " Edit Event"
        vc.competionHandler = {
            print($0)
            self.event = $0
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Xoa 1 Event
    @IBAction func btnDelete(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure ? ", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.presenter?.responseDataEvent(event: self.event)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil )
    }
    
}
// TableView
extension DetailEventController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
}

// View
extension DetailEventController{
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
        presenter?.still(event: event)
    }
}

extension DetailEventController : DetailPresenterDelegate{
    func responData(number: String) {
        lblStillDate.text = number
    }
    
    
    // setup view
    func setUpView()  {
        if  !checkDate.checkDate(dateEnd: event.date!) {
            btnStatus.setTitle("incomplete markup" , for: .normal)
            status = event.status!
            btnStatus.isEnabled = false
            
        } else if  event.status == "false"{
            btnStatus.setTitle("incomplete markup" , for: .normal)
            status = event.status!
            
        }
        else {
            status = "true"
        }
        imgEvent.image = UIImage(named: event.eventImage! )
        tfNameEvent.text = event.name
        lblDate.text = event.date
        lbMoney.text = format.formatInt(so: event.spent!)
    }
}

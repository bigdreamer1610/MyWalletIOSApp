//
//  AddEventTableController.swift
//  MyWalletProject
//
//  Created by Van Thanh on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit


class AddEventTableController: UITableViewController,UITextFieldDelegate {
        
    
    @IBAction func btCategory(_ sender: Any) {
        let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "CategoryEvent") as! CategoryEvent
                   vc .completionHandler = {
                       print($0)
                    self.categoryName = $0
                    self.imgCategory.image = UIImage(named: $0)
                   }
                   navigationController?.pushViewController(vc, animated: true)
        
        
    }
    var event = Event()
    
    var categoryName = ""
    @IBOutlet weak var tfNameEvent: UITextField!
    @IBOutlet weak var tfMoney: UITextField!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var viewCategory: UIView!
    
    
    
    @IBOutlet weak var cellEvent: UITableViewCell!
    var delegate: AddEventTableControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tfMoney.delegate = self
        viewCategory.layer.cornerRadius = viewCategory.frame.width / 2
        viewCategory.layer.cornerRadius = viewCategory.frame.height / 2
        
        

      
       
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
       
       setUpView()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let delegate = delegate {
                
                delegate.logoutTappped()
                
            }
        }
        if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "calendarView") as! CalendarController
            vc .completionHandler = {
                print($0)
                self.event.dateEnd = $0
                self.tfDate.text = $0
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 9
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    func setUpView()  {
        if event.name != nil {
                           tfNameEvent.text = event.name!
                           tfMoney.text = String(event.goal!)
                           tfDate.text = event.dateEnd!
                           imgCategory.image = UIImage(named: event.categoryid!)
                } else {
                    print("d km")
                }
      
    }
    
    
    

}

protocol AddEventTableControllerDelegate {
    func logoutTappped()
        
    
}

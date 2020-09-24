//
//  AddEventController.swift
//  MyWallet
//
//  Created by Van Thanh on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddEventController: UIViewController {
    var ref: DatabaseReference!
    var click = UITapGestureRecognizer()
    var txtDate : String?
    var categoryName = ""
    
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var imgCategory: UIImageView!
    
    @IBOutlet weak var edMoney: UITextField!
    
    @IBOutlet weak var edAddEvent: UITextField!
    @IBOutlet weak var tvDate: UITextField!
    
    
    @IBOutlet weak var vCategory: UIView!
    
    @IBAction func btCategory(_ sender: Any) {
        
        let categoery = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "CategoryEvent") as! CategoryEvent
        
        //
        categoery.completionHandler = {
            print($0)
            self.categoryName = $0
            self.edAddEvent.text = $0
            self.imgCategory.image = UIImage(named: $0)
        }
        self.navigationController?.pushViewController(categoery, animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        setUpView()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(leftAction))
       
        
    }
    
    
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    @objc func calendar(_sender: UITapGestureRecognizer ) {
        let calendar = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "calendarView") as! CalendarController
        calendar.completionHandler = {
            print($0)
            self.tvDate.text = $0
            
        }
        self.navigationController?.pushViewController(calendar, animated: true)
    }
//    @IBAction func unwindToAddViewController(_ unwindSegue: UIStoryboardSegue) {
//        if unwindSegue.identifier == "calendarView" {
//            let scen1 = unwindSegue.source as! CalendarController
//            print(scen1.dateLich)
//        } else if unwindSegue.identifier == "calendarView"  {
//                 let scen2 = unwindSegue.source as! CategoryEvent
//
//        }
//
//        // Use data from the view controller which initiated the unwind segue
//    }
        
    func setUpView()  {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(leftAction))
        ///
               let calendar1 = UITapGestureRecognizer(target: self, action: #selector(self.calendar(_sender:)))
               self.imgCalendar.addGestureRecognizer(calendar1)
               self.imgCalendar.isUserInteractionEnabled = true
        
        ////bat su kien view
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.calendar(_sender:)))
//                vCategory.addGestureRecognizer(gesture)
      
        
               let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "calendarView") as! CalendarController
        
        
       
        
        
    }
    @objc func leftAction(){
        
        if tvDate.text! != "" && (edMoney.text != "")  && (edAddEvent.text != "") {
            
            let event = ["dateEnd": tvDate.text, "dateStart": setDate(), "goal": edMoney.text, "name": edAddEvent.text] as [String : Any]
       
                   self.ref.child("Account").child("userid1").child("event").child(categoryName).setValue(event,withCompletionBlock: {
                                        error, ref in
                                        if error == nil {
                                            
                                        } else{
                                            
                                        }
                                    })
            
        } else {
            let alert = UIAlertController(title: "error", message: "Moi nhap day du", preferredStyle: UIAlertController.Style.actionSheet)
                       alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            
            }
        
       
       }
    
   

}

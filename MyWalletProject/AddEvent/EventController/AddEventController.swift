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
    var dayThis: Date?
    var newChild = 0
    var arrayNameEvent = [String]()
    
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
        getNewChildTitle()
        setUpView()
        
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
        //calendar.dateThis = dayThis
        calendar.completionHandler = {
            print($0)
            self.tvDate.text = $0
            
        }
        self.navigationController?.pushViewController(calendar, animated: true)
    }

        
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
            
            if  arrayNameEvent.contains(edAddEvent.text!) == false {
                
                let event = ["dateEnd": tvDate.text, "dateStart": setDate(), "goal": Int(edMoney.text!), "name": edAddEvent.text, "category": categoryName, "spent": 0] as [String : Any]
                       self.ref.child("Account").child("userid1").child("event").child("\(self.newChild)").updateChildValues(event,withCompletionBlock: { error , ref in
                           if error == nil {
                           
                        self.navigationController?.popViewController(animated: true)
                           }else{
                               //handle
                           }
                       } )
            } else {
                let alert = UIAlertController(title: "error", message: "Event này đã tồn tại", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
            }
            
            
        } else {
            let alert = UIAlertController(title: "error", message: "Moi nhap day du", preferredStyle: UIAlertController.Style.actionSheet)
                       alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            
            }
        
       
       }
    
 
    func getNewChildTitle(){
        ref.child("Account").child("userid1").child("event").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let self = self else {
                return
           }
            if snapshot.childrenCount == 0 {
                self.newChild = 0
            } else if snapshot.childrenCount != 0 {
                self.newChild = Int(snapshot.childrenCount)
            }
          
        }
    }
    
   

}

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
    
    var tableViewController: AddEventTableController = AddEventTableController()
    var completionHandler: ((Event) -> Void)?
    var ref: DatabaseReference!
    var click = UITapGestureRecognizer()
    var txtDate : String?
    var categoryName = ""
    var dayThis: Date?
    var newChild = 0
    var arrayNameEvent = [String]()
    let cell1 = "nameEventCell"
    let cell2 = "moneyEventCell"
    let cell3 = "calendarEventCell"
    var state = 1
    var event = Event()
   // cũ
    @IBOutlet weak var imgCalendar: UIImageView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var edMoney: UITextField!
    @IBOutlet weak var edAddEvent: UITextField!
    @IBOutlet weak var tvDate: UITextField!
    @IBOutlet weak var vCategory: UIView!
    // moi

    
    
    
    
    

    @IBOutlet weak var btSave: UIButton!
    @IBAction func btSave(_ sender: Any) {
        
        leftAction()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewController = self.children[0] as! AddEventTableController
        
        if state == 0  {
            self.title = "Edit Event"
            tableViewController.cellEvent.isUserInteractionEnabled = false
            tableViewController.event = self.event
            print("addcontroller\(tableViewController.event)")
            
        } else {
            self.title = "Add Event"
        }
        
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

    func setUpView()  {
        btSave.layer.cornerRadius = 10
        btSave.layer.masksToBounds = false
        btSave.layer.shadowOpacity = 0.5
        btSave.layer.shadowOffset = CGSize(width: 0, height: 5)
        btSave.layer.shadowColor = UIColor.black.cgColor
    }
    func leftAction(){
        if tableViewController.tfDate.text! != "" && (tableViewController.tfMoney.text != "")  && (tableViewController.tfNameEvent.text != "") {
            
            if  arrayNameEvent.contains((tableViewController.tfNameEvent.text)!) == false {
                print("edit\(tableViewController.imgCategory)")
                let event = [ "id": String(newChild),
                               "name": (tableViewController.tfNameEvent.text)! ,
                              "date": tableViewController.tfDate.text!,
                             "eventImage": tableViewController.event.eventImage,
                             "spent": 0]
                    as [String : Any]
                self.event.date = tableViewController.tfDate.text!
                self.event.spent = Int((tableViewController.tfMoney.text)!)
                       self.ref.child("Account").child("userid1").child("event").child("\(self.newChild)").updateChildValues(event,withCompletionBlock: { error , ref in
                           if error == nil {
                            self.completionHandler?(self.event)
                        self.navigationController?.popViewController(animated: true)
                           }else{
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.description as? AddEventTableController, segue.identifier == "AddEventTableController" {
//            self.infos = vc
//            tableViewController?.event = self.event
//
//        }
//    }
   

}
extension AddEventController:  AddEventTableControllerDelegate{
    func logoutTappped() {
        
        print("vanthanh")
        
    }
    
    
    
    
}

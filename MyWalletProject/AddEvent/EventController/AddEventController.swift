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
    var state = 1
    var event = Event()
    var string = Int()
    var userID = "userid1"
       
    
   // cũ
   
    // moi

    
    
    
    
    

    @IBOutlet weak var btSave: UIButton!
    @IBAction func btSave(_ sender: Any) {
        
        leftAction()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
        tableViewController = self.children[0] as! AddEventTableController
        
        if state == 0  {
            self.title = "Edit Event"
            tableViewController.cellEvent.isUserInteractionEnabled = false
            tableViewController.event = self.event
            print("addcontroller\(tableViewController.event)")
            
        } else {
            self.title = "Add Event"
              getNewChildTitle()
        }
        
       
       
        
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
        if state == 1 {
              if tableViewController.tfDate.text! != ""   && (tableViewController.tfNameEvent.text != "") {
                      
                      if  arrayNameEvent.contains((tableViewController.tfNameEvent.text)!) == false {
                          
                          let event = [ "id": String(newChild),
                                         "name": (tableViewController.tfNameEvent.text)! ,
                                        "date": tableViewController.tfDate.text!,
                                       "eventImage": tableViewController.eventImg,
                                       "spent": 0]
                              as [String : Any]
                          self.event.date = tableViewController.tfDate.text!
                  self.ref.child("Account").child(userID).child("event").child(String(string)).updateChildValues(event,withCompletionBlock: { error , ref in
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
        } else {
            if tableViewController.tfNameEvent.text != "" {
                if arrayNameEvent.contains(tableViewController.tfNameEvent.text!) == false {
                    newChild = Int(tableViewController.event.id!)!
                    let event = [ "id": String(newChild),
                                           "name": (tableViewController.tfNameEvent.text)! ,
                                          "date": tableViewController.tfDate.text!,
                                         "eventImage": tableViewController.eventImg,
                                         "spent": 0]
                                as [String : Any]
                            self.event.date = tableViewController.tfDate.text!
                    self.ref.child("Account").child(userID).child("event").child(String(newChild)).updateChildValues(event,withCompletionBlock: { error , ref in
                                       if error == nil {
                                        self.completionHandler?(self.event)
                                    self.navigationController?.popViewController(animated: true)
                                       }else{
                                       }
                                   } )
                }
            }
        }
       }

    func getNewChildTitle(){
        self.ref.child("Account").child(userID).child("event").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                snapshot in
                for category in snapshot.children{
                    print(snapshot.childrenCount)
                    if  snapshot.childrenCount == nil   {
                        self.string = 0
                    } else{
                        self.string = Int((category as AnyObject).key)! + 1
                        print(self.string)
                    }
                   
                    
                    
                }
                
            })
    
    }
    

   

}
extension AddEventController:  AddEventTableControllerDelegate{
    func logoutTappped() {
        
        print("vanthanh")
        
    }
    
    
    
    
}

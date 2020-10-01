//
//  EventController.swift
//  MyWallet
//
//  Created by Van Thanh on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   

    
    @IBOutlet weak var EventTable: UITableView!
    var ref : DatabaseReference!
    var idUser = "userid1"
    var dateThis = ""
    var arrEvent: [Event] = []{
        didSet{
            print("dachi")
            EventTable.reloadData()
        }
    }
    var arrNameEvent = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(leftAction))
        ref = Database.database().reference()
        dateThis = setDate()
       
        let nib = UINib(nibName: "EventCell", bundle: nil)
        EventTable.register(nib, forCellReuseIdentifier: "EventCell")
        EventTable.delegate = self
        EventTable.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataCurrenlyApplying()
        sg.selectedSegmentIndex = 0
    }
    
    
    @IBOutlet weak var sg: UISegmentedControl!
    @IBAction func smMode(_ sender: UISegmentedControl) {
        switch sg.selectedSegmentIndex {
        case 0:
            getDataCurrenlyApplying()
        case 1:
            getEventFinished()
        default:
            print("chon lai")
        }
    }
    
    
   
    
    
    func getDataCurrenlyApplying()  {
          arrEvent.removeAll()
              self.ref.child("Account").child(idUser).child("event").observe(.value) { snapshot in
                           for case let child as DataSnapshot in snapshot.children {
                               guard let dict = child.value as? [String: Any] else {
                                   return
                               }
                             let dateEnd = dict["date"] as! String
                              var check = self.checkDay(dayThis: self.dateThis, dateEnd: dateEnd)
                              if check {
                                          let id = dict["id"] as! String
                                          let img = dict["categoryid"] as! String
                                          let nameEvent = dict["name"] as! String
                                          let spent = dict["spent"] as! Int
                                          let event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent)
                        //        let event1 = Event(name: nameEvent, goal: money, dateStart: dateStars, dateEnd: dateEnd, categoryid: img, spent: spent)
                                self.arrNameEvent.append(nameEvent)
                                  self.arrEvent.append(event1)
                              }
                              else {
                                print(" dang dien ra ")
                            }
                           }
                       }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEvent.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.load(event: arrEvent[indexPath.row])
           return cell
         
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           100
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "DetailEvent")
        as! TableDetailEventController
        detail.event = arrEvent[indexPath.row]
        
        self.navigationController?.pushViewController(detail, animated: true)
       
    }
    
    
    
    
    @objc func leftAction() {
        let add = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "AddEvent") as! AddEventController
               //calendar.dateThis = dayThis
        add.arrayNameEvent = arrNameEvent
        arrEvent.removeAll()
        self.navigationController?.pushViewController(add, animated: true)
        
        
    }
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    func getEventFinished()  {
        arrEvent.removeAll()
        self.ref.child("Account").child(idUser).child("event").observe(.value) { snapshot in
                     for case let child as DataSnapshot in snapshot.children {
                         guard let dict = child.value as? [String: Any] else {
                             return
                         }
                       let dateEnd = dict["date"] as! String
                        var check = self.checkDay(dayThis: self.dateThis, dateEnd: dateEnd)
                        if check == false {
                               let id = dict["id"] as? String
                                let img = dict["categoryid"] as! String
                                let nameEvent = dict["name"] as! String
                                let spent = dict["spent"] as! Int
                                let event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent)
                            self.arrEvent.append(event1)
                        }
                        else {
                            print("da ket thuc")
                        }
                     }
                 }
    }
    
    func checkDay( dayThis: String , dateEnd: String) -> Bool {
        var checkday1 = false
       let dateFormat = "dd-MM-yyyy"
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = dateFormat
       let startDate = dateFormatter.date(from: dayThis)
       let endDate = dateFormatter.date(from: dateEnd)

       guard let startDate1 = startDate, let endDate2 = endDate else {
           fatalError("Date Format does not match ⚠️")
       }

        if startDate1 <= endDate2 {
           checkday1 = true
       } else if startDate1 > endDate2 {
            checkday1 = false
       }
        return checkday1

}

}





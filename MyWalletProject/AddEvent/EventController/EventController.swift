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
    var format = FormatNumber()
    var test = 0
    var arrEvent: [Event] = []{
        didSet{
            print("array Event \(arrNameEvent.count)")
            EventTable.reloadData()
        }
    }
    var arrNameEvent = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(leftAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .remove, style: .done, target: self, action: #selector(back))
        ref = Database.database().reference()
        dateThis = setDate()
       
        let nib = UINib(nibName: "EventCell", bundle: nil)
        EventTable.register(nib, forCellReuseIdentifier: "EventCell")
        EventTable.delegate = self
        EventTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        test = 0
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
        self.arrEvent.removeAll()
        self.arrNameEvent.removeAll()
        self.test = 0
        self.ref.child("Account").child(idUser).child("event").observeSingleEvent(of: .value, with: { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: Any] else {
                    return
                }
                let dateEnd = dict["date"] as! String
                let status = dict["status"] as! String
                var check = self.checkDay(dayThis: self.dateThis, dateEnd: dateEnd)
                if check && status == "true" {
                    let id = dict["id"] as! String
                    let img = dict["eventImage"] as! String
                    let nameEvent = dict["name"] as! String
                    let spent = dict["spent"] as! Int
                    
                    var event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                    self.test += 1
                    self.arrNameEvent.append(nameEvent)
                    self.arrEvent.append(event1)
                    
                   
                }
                else {
                    
                }
            }
            
           
        })
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
           80
        
       }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "DetailEvent")
        as! DetailEventController
        detail.event = arrEvent[indexPath.row]
        let presenter = DetailPresenter(delegate: detail, useCase: DetailEventUseCase())
        detail.setUp(presenter: presenter)
        self.navigationController?.pushViewController(detail, animated: true)
        
       
    }
    
    
    ///////// chon adđ
    
    @objc func leftAction() {
        let add = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "AddEventTableController") as! AddEventTableController
        let presenter = AddEventPresenter(delegate: add , userCase: AddEventTableUseCase())
        add.setUp(presenter: presenter)
        self.navigationController?.pushViewController(add, animated: true)
        
        
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    func getEventFinished()  {
         self.arrEvent.removeAll()
        self.arrNameEvent.removeAll()
        self.ref.child("Account").child(idUser).child("event").observe(.value) { snapshot in
                     for case let child as DataSnapshot in snapshot.children {
                         guard let dict = child.value as? [String: Any] else {
                            print("error")
                             return
                         }
                       let dateEnd = dict["date"] as! String
                        let status = dict["status"] as! String
                        var check = self.checkDay(dayThis: self.dateThis, dateEnd: dateEnd)
                        if check == false || status == "false" {

                               let id = dict["id"] as! String
                                let img = dict["eventImage"] as! String
                                let nameEvent = dict["name"] as! String
                                let spent = dict["spent"] as! Int
                                
                            var event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                            self.arrEvent.append(event1)
                            self.arrNameEvent.append(nameEvent)
                           
                        }
                        else {
                            
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
       } else  {
            checkday1 = false
       }
        return checkday1

}


}







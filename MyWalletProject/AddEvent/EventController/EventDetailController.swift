//
//  EventDetailController.swift
//  MyWallet
//
//  Created by Van Thanh on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class EventDetailController: UIViewController {

    @IBOutlet weak var btmarkCompleted: UIButton!
    @IBOutlet weak var btTransaction: UIButton!
    @IBOutlet weak var btDeleteEvent: UIButton!
    
    @IBOutlet weak var imgCategoryDetail: UIImageView!
    @IBOutlet weak var imgCalendar: UIImageView!
    
    @IBOutlet weak var nameEvent: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    var event = Event()
    var eventName = ""
    var eventDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButton()
        loadDetail(event: event)
        
        
    }
    
    
    func setUpButton() {
        //delete
        btDeleteEvent.layer.borderColor = UIColor.blue.cgColor
        btDeleteEvent.layer.borderWidth = 2
        btDeleteEvent.layer.cornerRadius = 15
        
        //transaction
        btTransaction.layer.borderColor = UIColor.blue.cgColor
        btTransaction.layer.borderWidth = 2
        btTransaction.layer.cornerRadius = 15
        
        //MarkCompleted
        btmarkCompleted.layer.borderColor = UIColor.blue.cgColor
        btmarkCompleted.layer.borderWidth = 2
        btmarkCompleted.layer.cornerRadius = 15
    }
    
    func loadDetail(event: Event) {
        nameEvent.text = event.name!
        tfDate.text = event.dateEnd!
        imgCategoryDetail.image = UIImage(named: event.categoryid!)
    }
    
    
}

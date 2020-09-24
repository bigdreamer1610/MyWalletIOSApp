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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButton()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  AddEventTableController.swift
//  MyWalletProject
//
//  Created by Van Thanh on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit


class AddEventTableController: UITableViewController {
    var competionHandler: ((Event) -> Void)?
    var nameEvents = [String]()
    var event = Event()
    var eventImg = ""
    var presenter : AddEventPresenter?
    var state = 0
    var nameEvent = ""
    var defined = EventDefined()
    
    // OutLet
    
    @IBOutlet weak var tfNameEvent: UITextField!
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var cellEvent: UITableViewCell!
    
    
    //Load view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let tapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(keyBoard))
        tapGestureRecognizer.cancelsTouchesInView = false
        setUpView()
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setUp(presenter: AddEventPresenter)  {
        self.presenter = presenter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpViewImg()
    }
    
    @IBAction func btnSave(_ sender: Any) {        
        add()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btCategory(_ sender: Any) {
        self.acctionImgEvent()
    }
    
    func setUpView()  {
        
        if event.name != nil {
            viewImg.alpha = 0
            tfNameEvent.text = event.name!
            tfDate.text = event.date!
            imgCategory.image = UIImage(named: event.eventImage!)
            eventImg = event.eventImage!
        } else {
        }
        
    }
}
extension AddEventTableController : AddEventPresenterDelegate, UITextFieldDelegate{
    func data(event: Event) {
        self.event = event
    }
    
    func setUpViewImg() {
        
        viewCategory.layer.cornerRadius = viewCategory.frame.width / 2
        viewCategory.layer.cornerRadius = viewCategory.frame.height / 2
        viewImg.layer.cornerRadius = viewImg.frame.width / 2
        viewImg.layer.cornerRadius = viewImg.frame.height / 2
    }
    // gioi han ky tu nhap vao name event
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = textField.text as! NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    // bat su kien click vào cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "calendarView") as! CalendarController
            vc .completionHandler = {
                print($0)
                self.event.date = $0
                self.tfDate.text = $0
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // chon anh event
    
    func acctionImgEvent()  {
        let vc = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "CategoryEvent") as! EventImgViewController
        vc .completionHandler = {
            self.eventImg = $0
            self.imgCategory.image = UIImage(named: $0)
            self.viewImg.alpha = 0
        }
        let presenter = EventImgPresenter(delegate: vc, usecase: EventImgUseCase())
        vc.setUp(presenter: presenter)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc  func keyBoard() {
        view.endEditing(true)
    }
    func add()  {
        if state == 0  {
            nameEvent = tfNameEvent.text?.trimmingCharacters(in: .whitespaces) as! String
            if !nameEvents.contains(nameEvent) {
                if tfDate.text!.isEmpty || nameEvent.isEmpty || eventImg.isEmpty {
                    let alert = defined.alert(state: state)
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    let event = Event(id: nil, name: nameEvent, date: tfDate.text!, eventImage: eventImg, spent: 0)
                    self.presenter?.addDataEvent(event: event, state: state)
                }
            } else {
                let alert = defined.alert(state: 4)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else {
            if tfDate.text!.isEmpty && tfNameEvent.text!.isEmpty && eventImg.isEmpty {
            }else {
                let event = Event(id: self.event.id, name: tfNameEvent.text!, date: tfDate.text!, eventImage: eventImg, spent: self.event.spent, status: self.event.status)
                competionHandler?(event)
                self.presenter?.addDataEvent(event: event, state: state)
            }
            
        }
        
    }
    
    
}
extension AddEventTableController {
    override var hidesBottomBarWhenPushed: Bool {
        get{
            return true
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
}







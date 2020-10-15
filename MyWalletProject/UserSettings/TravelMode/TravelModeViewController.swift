//
//  TravelModeViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class TravelModeViewController: UIViewController {

    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var labelEventView: UIView!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var lblSelectEvent: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    var switchState = false
    var travelModeState = false
    var delegate: SelectEvent?
    var event: Event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.travelMode
        
        addBorder([switchView, eventView])
        setupGestureForView([eventView])
        
        initEventView()
    }
    
    // MARK: - Get data from user defaults
    func getDataFromUserDefaults() {
        self.event.id = Defined.defaults.string(forKey: Constants.eventTravelId)
        self.event.eventImage = Defined.defaults.string(forKey: Constants.eventTravelImage)
        self.event.name = Defined.defaults.string(forKey: Constants.eventTravelName)
    }
    
    // MARK: - Init event view
    func initEventView() {
        self.travelModeState = Defined.defaults.bool(forKey: Constants.travelState)
        self.switchState = self.travelModeState
        
        if !travelModeState {
            labelEventView.alpha = 0
            eventView.alpha = 0
            `switch`.isOn = false
        } else {
            getDataFromUserDefaults()
            
            labelEventView.alpha = 1
            eventView.alpha = 1
            
            if let imageName = self.event.eventImage {
                imgEvent.image = UIImage(named: imageName)
            }
            if let eventName = self.event.name {
                lblSelectEvent.text = eventName
            }
            lblSelectEvent.textColor = .systemGray2
            
            `switch`.isOn = true
        }
    }
    
    // MARK: - Add bottom and top border for views
    func addBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-1, width: view.frame.width, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(bottomBorder)
            
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 1.0)
            topBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(topBorder)
        }
    }
    
    // MARK: - Setup gesture on view
    func setupGestureForView(_ views: [UIView]) {
        views.forEach { (view) in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let vc = RouterType.selectEvent.getVc() as! SelectEventController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performAnimation(duration: Double, value: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.labelEventView.alpha = value
            self.eventView.alpha = value
        })
    }
    
    @IBAction func switchOn(_ sender: Any) {
        if !switchState {
            performAnimation(duration: 0.5, value: 1)
            imgEvent.image = UIImage(named: "s-defaultimage")
            lblSelectEvent.text = "Select event"
            lblSelectEvent.textColor = .systemGray2
            switchState = true
        } else {
            performAnimation(duration: 0.5, value: 0)
            switchState = false
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        self.travelModeState = self.switchState
        
        if self.travelModeState {
            if lblSelectEvent.text != "Select event" {
                Defined.defaults.set(self.travelModeState, forKey: Constants.travelState)
                Defined.defaults.set(self.event.id, forKey: Constants.eventTravelId)
                Defined.defaults.set(self.event.eventImage, forKey: Constants.eventTravelImage)
                Defined.defaults.set(self.event.name, forKey: Constants.eventTravelName)
                self.navigationController?.popViewController(animated: true)
                
            }
        } else {
            Defined.defaults.set(false, forKey: Constants.travelState)
            Defined.defaults.removeObject(forKey: Constants.eventTravelId)
            Defined.defaults.removeObject(forKey: Constants.eventTravelImage)
            Defined.defaults.removeObject(forKey: Constants.eventTravelName)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
}

extension TravelModeViewController: SelectEvent {
    func setEvent(nameEvent: String, imageEvent: String, eventid: String) {
        self.imgEvent.image = UIImage(named: imageEvent)
        self.lblSelectEvent.text = nameEvent
        self.lblSelectEvent.textColor = .black
        
        self.event.eventImage = imageEvent
        self.event.name = nameEvent
        self.event.id = eventid
    }
}

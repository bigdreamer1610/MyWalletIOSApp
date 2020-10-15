//
//  SelectEventUserCase.swift
//  MyWalletProject
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

enum EventStatus: String {
    case applying = "true"
    case finish = "false"
    
    func getValue() -> String {
        return self.rawValue
    }
}

protocol SelectEventUserCaseDelegate: class{
    func responseData(data: [Event])
}
class SelectEventUserCase {
    var events = [Event]()
    var delegate: SelectEventUserCaseDelegate?
}

extension SelectEventUserCase{
    func getDataFromFirebase() {
        Defined.ref.child(Path.event.getPath()).observe(DataEventType.value) { [weak self](snapshot) in
            guard let `self` = self else {return}
            var events = [Event]()
            for case let snapshots as DataSnapshot in snapshot.children {
                guard let dict = snapshots.value as? [String:Any] else {
                    return
                }
                do {
                    let model = try FirebaseDecoder().decode(Event.self, from: dict)
                    if model.status == EventStatus.applying.getValue() {
                        events.append(model)
                    }
                } catch let error {
                }
            }
            self.delegate?.responseData(data: events)
        }
    }
}

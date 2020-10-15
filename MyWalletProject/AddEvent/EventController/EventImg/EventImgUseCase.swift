//
//  EventImgUseCase.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol EventImgUseCaseDelegate: class {
    func data(imgEvents: [String])
}

class EventImgUseCase {
    var idUser = "userid1"
    var imgEvents = [String]()
    weak var delegate: EventImgUseCaseDelegate?
    
    
    // Get data Firebase
    func fetchData()  {
        Defined.ref.child(Path.imageLibrary.getPath()).observe( .value) { (snapshot) in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String : Any] else {
                    print("error")
                    return
                }
                let img = dict["iconImage"] as! String
                self.imgEvents.append(img)
            }
            self.delegate?.data(imgEvents: self.imgEvents)

        }

        
        // limit
        
    }
    
}

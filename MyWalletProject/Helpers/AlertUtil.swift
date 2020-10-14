//
//  AlertUtil.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    class func showAlert(from viewController: UIViewController, with title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    class func showAlert(from viewController: UIViewController, with title: String, message: String,  completion : (@escaping (UIAlertAction) -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .cancel, handler: completion)
            alert.addAction(doneAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}


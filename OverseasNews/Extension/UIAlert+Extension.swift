//
//  UIAlert+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/30.
//

import UIKit

class AlertHelper {
        static func defaultAlert(title: String?, message: String?, okMessage: String, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: okMessage, style: .default, handler: nil))
        viewController.present(ac, animated: true)
    }
}

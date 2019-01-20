//
//  Constant.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation
import UIKit

struct APIConstant {
    static let scheme = "http"
    static let host = "api.etherscan.io"
    static let apiKey = "569PWSGAB49Z4XDUS9NS8Q53EFMMGF91WB"
}

struct UserDefaultConstants {
    
    static let transactionAddress: String = "transactionAddress"
    static let transactionWalletName: String = "transactionWalletName"
    static let isAppFirstTime: String = "isAppFirstTime"
    
    static let settingUpdateNotification: Notification.Name = Notification.Name(rawValue: "settingUpdateNotification")
}

extension UIView {
    func setLeftSideCornerRadius(cornerRadius: Double) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
        
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            let headerViewPath = UIBezierPath(roundedRect:(self.bounds),
                                              byRoundingCorners:[.topLeft, .bottomLeft],
                                              cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let headerViewMaskLayer = CAShapeLayer()
            headerViewMaskLayer.path = headerViewPath.cgPath
            self.layer.mask = headerViewMaskLayer
        }
    }
}

extension NotificationCenter {
    func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}



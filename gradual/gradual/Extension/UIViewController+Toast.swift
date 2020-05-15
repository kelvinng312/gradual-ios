//
//  UIViewController+Toast.swift
//  gradual
//
//  Created by Admin on 5/15/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import Foundation
import UIKit
import Toaster

extension UIViewController {
    func showMessage(message: String?, bottomOffset: CGFloat? = nil) {
        if let message = message, !message.isEmpty {
            let toast = Toast(text: message)
            if let bottomOffset = bottomOffset {
                toast.view.bottomOffsetPortrait = bottomOffset
            }
            toast.show()
        } else {
            let toast = Toast(text: "Something went wrong")
            if let bottomOffset = bottomOffset {
                toast.view.bottomOffsetPortrait = bottomOffset
            }
            toast.show()
        }
    }
}

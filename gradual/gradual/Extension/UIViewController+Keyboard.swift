//
//  UIViewController+Keyboard.swift
//  SPlanner
//
//  Created by Wanjing Xie on 10/13/19.
//  Copyright © 2019 Wanjing Xie. All rights reserved.
//

import UIKit



extension UIViewController {
    static var bottomConstraintForPushView: NSLayoutConstraint = NSLayoutConstraint()
    
    func dismissKeyboardWhenTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
}

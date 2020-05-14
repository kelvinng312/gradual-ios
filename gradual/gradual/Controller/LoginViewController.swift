//
//  LoginViewController.swift
//  gradual
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.text = "test1@gmail.com"
        txtPassword.text = "11111111"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginTouch(_ sender: Any) {
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        let parameters = LoginRequest(email: email, password: password)
        
        SVProgressHUD.show()
        let loginApiCall = LoginApiCall(parameters: parameters, success: { response in
            SVProgressHUD.dismiss()
            if !response.token.isEmpty {
                Preference.userID = response.id
                Preference.stripeKey = response.publishable_key
                Preference.customerID = response.customer_id
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            }
        }, failure: {
            SVProgressHUD.dismiss()
        })
        loginApiCall.call()
    }
    
    @IBAction func unwind(_ seg: UIStoryboardSegue) {
        
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

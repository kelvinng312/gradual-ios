//
//  SignUpViewController.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtEmail: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!
    @IBOutlet weak var txtConfirmPassword: DesignableUITextField!
    @IBOutlet weak var txtName: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dismissKeyboardWhenTouch()
    }
    
    @IBAction func btnSignUpTouch(_ sender: Any) {
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""
        let name = txtName.text ?? ""
        let parameters = SignUpRequest(name: name, email: email, password: password, confrimPassword: confirmPassword)
        
        SVProgressHUD.show()
        let signUpApiCall = SignUpApiCall(parameters: parameters, success: { response in
            SVProgressHUD.dismiss()
            if !response.token.isEmpty {
                Preference.userID = response.id
                Preference.stripeKey = response.publishable_key
                Preference.customerID = response.customer_id
                self.performSegue(withIdentifier: "signUpSuccess", sender: nil)
            }
        }, failure: {
            SVProgressHUD.dismiss()
        })
        signUpApiCall.call()
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

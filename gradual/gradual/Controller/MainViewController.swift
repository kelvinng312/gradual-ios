//
//  MainViewController.swift
//  gradual
//
//  Created by Admin on 5/13/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import UIKit
import AVFoundation
import Stripe
import Lottie
import SVProgressHUD
import Toaster

class MainViewController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBottomBlank: UIView!
    
    @IBOutlet weak var viewDonateAnimation: AnimationView!
    @IBOutlet weak var viewSuccessAnimation: AnimationView!
    
    @IBOutlet weak var imgSender: UIImageView!
    @IBOutlet weak var lblSender: UILabel!
    
    @IBOutlet weak var txtCardInput: STPPaymentCardTextField!
    
    var playerDonateSound: AVAudioPlayer?
    var playerSuccessSound: AVAudioPlayer?
    
    var donee: Donee?
    var imgDonee: UIImage?
    var stripe: Stripe?
    
    var bottomOffset: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        initializeAnimationAndSound()
        initializeStripe()
    }
    
    @IBAction func btnDonateTouch(_ sender: Any) {
        if Preference.customerID == nil || Preference.customerID == "" {
            if !txtCardInput.isValid {
                showMessage(message: "Please input card information correctly", bottomOffset: bottomOffset)
                return
            }
        }
        
        bottomOffset = viewBottomBlank.frame.height + 35
        txtCardInput.isHidden = true
        playerDonateSound?.play()
        
        viewDonateAnimation.currentProgress = 0
        viewDonateAnimation.pause()
        viewDonateAnimation.play()
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

extension MainViewController {
    func initializeView() {
        pushViewWhenKeyboardAppear()
        dismissKeyboardWhenTouch()
        
        imgSender.image = imgDonee
        lblSender.text = donee?.name
        txtCardInput.translatesAutoresizingMaskIntoConstraints = false
        if let customerID = Preference.customerID, !customerID.isEmpty {
            txtCardInput.isHidden = true
        } else {
            txtCardInput.isHidden = false
        }
        viewDonateAnimation.currentProgress = 1
    }
    
    func initializeAnimationAndSound() {
        guard let button_sound_url = Bundle.main.url(forResource: "button_sound", withExtension: "mp3") else { return }
        guard let success_sound_url = Bundle.main.url(forResource: "success_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            playerDonateSound = try AVAudioPlayer(contentsOf: button_sound_url, fileTypeHint: AVFileType.mp3.rawValue)
            playerSuccessSound = try AVAudioPlayer(contentsOf: success_sound_url, fileTypeHint: AVFileType.mp3.rawValue)
            
            playerDonateSound?.delegate = self
            playerSuccessSound?.delegate = self
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func initializeStripe() {
        guard let stripeKey = Preference.stripeKey else {
            //TODO: go to login page or something
            return
        }
        Stripe.setDefaultPublishableKey(stripeKey)
    }
    
    func startDonate() {
        viewDonateAnimation.currentProgress = 1
        viewDonateAnimation.isHidden = true
        
        let cardParams = txtCardInput.cardParams
        pay(cardParams)
    }
    
    func stopSuccess() {
        viewSuccessAnimation.currentProgress = 0
        viewSuccessAnimation.pause()
        viewDonateAnimation.isHidden = false
    }
    
    func pay(_ cardParams: STPPaymentMethodCardParams) {
        if let customerID = Preference.customerID, !customerID.isEmpty {
            payWithCustomerID(customerID)
        } else {
            SVProgressHUD.show()
            
            let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
            STPAPIClient.shared().createPaymentMethod(with: paymentMethodParams) { [weak self] paymentMethod, error in
                SVProgressHUD.dismiss()
                
                // Create PaymentMethod failed
                if error != nil {
                    self?.onPaymentIncompleted("Fail to create payment method")
                }
                if let paymentMethodId = paymentMethod?.stripeId {
                    print("Created PaymentMethod")
                    self?.payWithPaymentMethodID(paymentMethodId)
                }
            }
        }
    }
    
    func payWithCustomerID(_ customerID: String) {
        guard let userID = Preference.userID else { return }
        guard let receiveUserID = donee?.id else { return }
        
        SVProgressHUD.show()
        
        let parameters = PayAgainRequest(userID: userID, customerID: customerID, receivedUserID: receiveUserID)
        let payAgainApiCall = PayAgainApiCall(parameters: parameters, success: { [weak self] response in
            SVProgressHUD.dismiss()
            
            self?.processPayResponse(response)
        }, failure: {
            SVProgressHUD.dismiss()
            
            self.onPaymentIncompleted("Fail to pay with customer ID")
        })
        payAgainApiCall.call()
    }
    
    func payWithPaymentMethodID(_ paymentMethodID: String) {
        guard let userID = Preference.userID else { return }
        guard let receiveUserID = donee?.id else { return }
        
        SVProgressHUD.show()
        
        let parameters = PayFirstRequest(userID: userID, paymentMethodID: paymentMethodID, receiveUserID: receiveUserID)
        let payFirstApiCall = PayFirstApiCall(parameters: parameters, success: { [weak self] response in
//            print(response)
            SVProgressHUD.dismiss()
            
            self?.processPayResponse(response)
        }, failure: {
            SVProgressHUD.dismiss()
            
            self.onPaymentIncompleted("Fail to pay with method ID")
        })
        payFirstApiCall.call()
    }
    
    func confirmPayment(_ paymentIntentID: String) {
        guard let userID = Preference.userID else { return }
        
        SVProgressHUD.show()
        
        let parameters = PayConfirmRequest(userID: userID, paymentIntentID: paymentIntentID)
        let payConfirmApiCall = PayConfirmApiCall(parameters: parameters, success: { [weak self] response  in
            SVProgressHUD.dismiss()
            
            self?.processPayResponse(response)
        }, failure: {
            SVProgressHUD.dismiss()
            
            self.onPaymentIncompleted("Fail to confirm payment")
        })
        payConfirmApiCall.call()
    }
    
    func processPayResponse(_ response: PayResponse) {
        if response.status == "error" {
            onPaymentIncompleted(response.error)
        } else if response.status == "accumulated" {
            onPaymentIncompleted(response.error)
        } else if response.status == "success" {
            if !response.customerID.isEmpty {
                Preference.customerID = response.customerID
            }
            
            if !response.clientSecret.isEmpty {
                if response.requiresAction {
                    self.handleNextActionForPayment(response.clientSecret)
                } else {
                    onPaymentSuccess()
                }
            }
        }
    }
    
    func handleNextActionForPayment(_ paymentIntentClientSecret: String) {
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.handleNextAction(forPayment: paymentIntentClientSecret, authenticationContext: self, returnURL: nil) { status, paymentIntent, handleActionError in
            switch (status) {
            case .failed:
                self.showMessage(message: "Payment request failed", bottomOffset: self.bottomOffset)
                break
            case .canceled:
                self.showMessage(message: "Payment request cancelled", bottomOffset: self.bottomOffset)
                break
            case .succeeded:
                // After handling a required action on the client, the status of the PaymentIntent is
                // requires_confirmation. You must send the PaymentIntent ID to your backend
                // and confirm it to finalize the payment. This step enables your integration to
                // synchronously fulfill the order on your backend and return the fulfillment result
                // to your client.
                if let paymentIntent = paymentIntent, paymentIntent.status == STPPaymentIntentStatus.requiresConfirmation {
                    print("Re-confirming PaymentIntent after handling action")
                    self.confirmPayment(paymentIntent.stripeId)
                }
                else {
                    self.onPaymentSuccess()
                }
                
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func onPaymentSuccess() {
        playerSuccessSound?.play()
        
        viewSuccessAnimation.currentProgress = 0
        viewSuccessAnimation.loopMode = .loop
        viewSuccessAnimation.play(completion: { _ in
            self.viewSuccessAnimation.currentProgress = 0
        })
    }
    
    func onPaymentIncompleted(_ message: String) {
        viewDonateAnimation.isHidden = false
        showMessage(message: message, bottomOffset: bottomOffset)
    }
}

extension MainViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == playerDonateSound {
            self.startDonate()
        } else if player == playerSuccessSound {
            self.stopSuccess()
        }
    }
}

extension MainViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension MainViewController {
    func pushViewWhenKeyboardAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        let bottomPadding = viewBottomBlank.frame.height
        let bottomOffset = keyboardSize > bottomPadding ? keyboardSize - bottomPadding : 0
        
        topConstraint.constant = 56 - bottomOffset
        bottomConstraint.constant = bottomOffset
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        topConstraint.constant = 56
        bottomConstraint.constant = 0

        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgSender.image = imgDonee
        lblSender.text = donee?.name
//        guard let url = Bundle.main.url(forResource: "button_sound", withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            playerDonateSound = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let playerDonateSound = playerDonateSound else { return }
//
//            playerDonateSound.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
//        viewDonateAnimation.play()
//        viewSuccessAnimation.contentMode = .scaleAspectFill
//        viewSuccessAnimation.loopMode = .loop
//        viewSuccessAnimation.play()
    }
    
    @IBAction func btnDonateTouch(_ sender: Any) {
        //TODO: check customer id
        let cardParams = txtCardInput.cardParams
        
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
    func setDonee() {
        
    }
    
    func pay(_ cardParams: STPPaymentMethodCardParams) {
        if let customerID = Preference.customerID, !customerID.isEmpty {
            payWithCustomerID(customerID)
        } else {
            
        }
    }
    
    func payWithCustomerID(_ customerID: String) {
        
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

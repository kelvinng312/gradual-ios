//
//  DoneeCollectionViewCell.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import UIKit

class DoneeCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var donee: Donee? {
        willSet {
            guard let donee = newValue else { return }
            
            let name = donee.name
            let avatar = donee.avatar.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            if let avatar = avatar, let avatarURL = URL(string: avatar) {
                self.imgAvatar.af.setImage(withURL: avatarURL)
            }
            self.lblName.text = name
        }
    }
}

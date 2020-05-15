//
//  DoneesViewController.swift
//  gradual
//
//  Created by Admin on 5/10/20.
//  Copyright © 2020 everydev. All rights reserved.
//

import UIKit
import AlamofireImage

class DoneesViewController: UIViewController {

    var donees: [Donee] = []
    @IBOutlet weak var doneesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters = DoneesRequest()
        let doneesApiCall = DoneesApiCall(parameters: parameters, success: { response in
            self.donees = response.donees.filter({ $0.id != Preference.userID })
            self.doneesCollectionView.reloadData()
        }, failure: {
            
        })
        doneesApiCall.call()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToDonees(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "donate" {
            guard let mainViewController = segue.destination as? MainViewController else { return }
            guard let doneeCollectionViewCell = sender as? DoneeCollectionViewCell else { return }
            
            mainViewController.imgDonee = doneeCollectionViewCell.imgAvatar.image
            mainViewController.donee = doneeCollectionViewCell.donee
        }
    }

}

extension DoneesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donee", for: indexPath) as! DoneeCollectionViewCell
        let index = indexPath.item
        
        cell.donee = donees[index]
//        let name = donees[index].name
//        let avatar = donees[index].avatar.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//
//        if let avatar = avatar, let avatarURL = URL(string: avatar) {
//            cell.imgAvatar.af.setImage(withURL: avatarURL)
//        }
//
//        cell.lblName.text = name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 40
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 8, bottom: 8, right: 8)
    }
}

//
//  FriendCellVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/10/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class FriendCellVC: UITableViewCell
{
    var friend: Friend?
    var delegate: ShowAlert?
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var RequestPendingLabel: UILabel!
    
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var DeclineButton: UIButton!
    
    @IBAction func AcceptRequest() {
        
        guard let friend = friend else {
            self.delegate?.showAlert(title: nil, message: "Unable to accept request, please try again later")
            return
        }
        
        FirebaseManager.sharedInstance.AcceptFriendRequest(friend, success: { error in
            guard error != nil else { return }
            self.delegate?.showAlert(title: nil, message: "Unable to accept request, please try again later")
        })
    }
    
    @IBAction func DeclineRequest() {
        
        guard let userId = friend?.userID else {
            self.delegate?.showAlert(title: nil, message: "Unable to decline request, please try again later")
            return
        }
        
        FirebaseManager.sharedInstance.DeclineFriendRequest(userId, success: { error in
            guard error != nil else { return }
            self.delegate?.showAlert(title: nil, message: "Unable to decline request, please try again later")
        })
    }
}

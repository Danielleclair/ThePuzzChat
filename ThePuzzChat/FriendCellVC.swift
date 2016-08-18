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
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var RequestPendingLabel: UILabel!
    
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var DeclineButton: UIButton!
    
    @IBAction func AcceptRequest() {
        
        if (friend != nil)
        {
            FirebaseManager.sharedInstance.AcceptFriendRequest(friend!.userID)
        }
    }
    
    @IBAction func DeclineRequest() {
        
        if (friend != nil)
        {
            FirebaseManager.sharedInstance.DeclineFriendRequest(friend!.userID)
        }
    }
}
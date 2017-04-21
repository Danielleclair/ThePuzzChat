//
//  AddFriendVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 1/31/17.
//  Copyright © 2017 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class AddFriendVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func addFriend() {
        if let email = usernameTextField.text {
            errorMessage.isHidden = !email.isEmpty
            FirebaseManager.sharedInstance.SendFriendRequest(with: email, success: { error in
                guard let error = error else {
                    //User.sharedInstance.friendsList.append(Friend(userName: email, requestAccepted: Friend.RequestStatus.awaitingResponse.rawValue))
                    //NotificationCenter.default.post(name: Notification.Name(rawValue: "FriendsListUpdated"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                
                if let puzzChatError = error as? PuzzChatError {
                    alert.message = puzzChatError.rawValue
                } else { //Default
                   alert.message = "Unable to add friend. Please try again later"
                }
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
}

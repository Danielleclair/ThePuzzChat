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
            FirebaseManager.sharedInstance.SendFriendRequest(with: email)
        }
    }
}

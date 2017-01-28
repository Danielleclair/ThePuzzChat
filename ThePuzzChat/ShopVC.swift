//
//  ShopVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/26/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class ShopVC: UIViewController, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var UsernameTextField: UITextField!
   
    @IBAction func Submit(_ sender: AnyObject) {
        
        if (UsernameTextField.text != nil)
        {
            FirebaseManager.sharedInstance.SendFriendRequestToUser(UsernameTextField.text!) { (String) in }
        }
    }
}

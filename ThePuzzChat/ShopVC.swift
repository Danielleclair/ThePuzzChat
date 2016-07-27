//
//  ShopVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/26/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class ShopVC: UIViewController, UIPopoverPresentationControllerDelegate
{
    @IBOutlet weak var UsernameTextField: UITextField!
   
    @IBAction func Submit(sender: AnyObject) {
        
        FirebaseManager.sharedInstance.AddFriendToFriendsList("Zalandrys") { (String) in
        }
    }
}
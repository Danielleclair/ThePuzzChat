//
//  PuzzatarCreationVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class PuzzatarCreationVC: UIViewController
{
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBAction func CreateUserAccount(sender: AnyObject) {
        
        if (UsernameTextField.text != nil)
        {
            FirebaseManager.sharedInstance.AddNewUser(UsernameTextField.text!, callback: { (success) in
                
                if (success)
                {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("HomeScreenSegue", sender: nil)
                    })
                }
            })
        }
    }
}
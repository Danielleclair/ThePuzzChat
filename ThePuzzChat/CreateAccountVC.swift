//
//  CreateAccount.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController
{
    @IBOutlet weak var EmailTextBox: UITextField!
    @IBOutlet weak var PasswordTextBox: UITextField!
    
    @IBAction func CreateAccount(sender: AnyObject) {
        
        if (EmailTextBox.text != nil)
        {
            if (PasswordTextBox.text != nil)
            {
                FirebaseManager.sharedInstance.CreateNewUser(EmailTextBox.text!, password: PasswordTextBox.text!, callback: { (errorMessage) in
                    
                    print(errorMessage)
                })
            }
        }
    }
}
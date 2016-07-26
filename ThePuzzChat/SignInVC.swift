//
//  SignInVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/16/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class SignInVC: UIViewController
{
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func SignIn(sender: AnyObject) {
        
        if (EmailTextField.text != nil)
        {
            if (PasswordTextField.text != nil)
            {
               
                FirebaseManager.sharedInstance.SignIn(EmailTextField.text!, password: PasswordTextField.text!, callback: { (success, message) in
                    
                    if (success)
                    {
                        self.performSegueWithIdentifier("SignInSegue", sender: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Sign In Error", message: message, preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                        alert.addAction(okAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                
                
                
                
            }
        }
    }
}
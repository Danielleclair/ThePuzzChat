//
//  CreateAccount.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var EmailTextBox: UITextField!
    @IBOutlet weak var PasswordTextBox: UITextField!
    
    override func viewDidLoad() {
        EmailTextBox.delegate = self
        PasswordTextBox.delegate = self
    }
    
    @IBAction func Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CreateAccount(sender: AnyObject) {
        
        if (EmailTextBox.text != nil)
        {
            if (PasswordTextBox.text != nil)
            {
                FirebaseManager.sharedInstance.CreateNewUser(EmailTextBox.text!, password: PasswordTextBox.text!, callback: { (success ,errorMessage) in
                    
                    if (!success)
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let alert = UIAlertController(title: "Account Creation Error", message: errorMessage, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                    else
                    {
                        //User created successfully
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("CreatePuzzatarSegue", sender: nil)
                        })
                    }
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
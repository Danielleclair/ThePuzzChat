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
    
    @IBAction func BackButton() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SignIn(_ sender: AnyObject) {
            
        if (EmailTextField.text != nil)
        {
            if (PasswordTextField.text != nil)
            {
                FirebaseManager.sharedInstance.SignIn(EmailTextField.text!, password: PasswordTextField.text!, callback: { (success, message) in
                    if (!success) {
                        let alert = UIAlertController(title: "Sign In Error", message: message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}

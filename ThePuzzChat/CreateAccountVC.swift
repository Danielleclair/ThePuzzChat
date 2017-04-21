//
//  CreateAccount.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.hideKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        emailTextBox.delegate = self
        passwordTextBox.delegate = self
    }
    
    @IBAction func CreateAccount(_ sender: AnyObject) {
        
        if (emailTextBox.text != nil)
        {
            if (passwordTextBox.text != nil)
            {
                FirebaseManager.sharedInstance.CreateNewUser(emailTextBox.text!, password: passwordTextBox.text!, callback: { (success ,errorMessage) in
                    
                    if (!success)
                    {
                        let alert = UIAlertController(title: "Account Creation Error", message: errorMessage, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        //User created successfully
                        self.performSegue(withIdentifier: "CreatePuzzatarSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showKeyboard()
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func showKeyboard() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100.0), animated: true)

    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

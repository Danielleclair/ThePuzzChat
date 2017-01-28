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
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var EmailTextBox: UITextField!
    @IBOutlet weak var PasswordTextBox: UITextField!
    
    override func viewDidLoad() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.hideKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        EmailTextBox.delegate = self
        PasswordTextBox.delegate = self
    }
    
    @IBAction func Back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateAccount(_ sender: AnyObject) {
        
        if (EmailTextBox.text != nil)
        {
            if (PasswordTextBox.text != nil)
            {
                FirebaseManager.sharedInstance.CreateNewUser(EmailTextBox.text!, password: PasswordTextBox.text!, callback: { (success ,errorMessage) in
                    
                    if (!success)
                    {
                        DispatchQueue.main.async(execute: {
                            
                            let alert = UIAlertController(title: "Account Creation Error", message: errorMessage, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                    else
                    {
                        //User created successfully
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "CreatePuzzatarSegue", sender: nil)
                        })
                    }
                })
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        ScrollView.setContentOffset(CGPoint(x: 0, y: 100.0), animated: true)
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

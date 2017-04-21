//
//  SignInVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/16/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class SignInVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardDidShow, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signIn(_ sender: AnyObject) {
        if (emailTextField.text != nil)
        {
            if (passwordTextField.text != nil)
            {
                FirebaseManager.sharedInstance.SignIn(emailTextField.text!, password: passwordTextField.text!, callback: { (success, message) in
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

    func showKeyboard(notification: Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
        scrollView.scrollRectToVisible(signInButton.frame, animated: true)
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
}

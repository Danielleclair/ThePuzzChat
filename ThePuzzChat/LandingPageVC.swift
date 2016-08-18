//
//  LandingPageVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class LandingPageVC: UIViewController
{
    
        
    @IBOutlet weak var CreateAccountButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        hideInterface()
        
        //Check authorization status
        FirebaseManager.sharedInstance.GetUserAuthState { (authorized, usernameSelected) in
         
            if (authorized && usernameSelected)
            {
                self.performSegueWithIdentifier("userAuthSegue", sender: nil)
                self.showInterface()
            }
            else if (authorized && !usernameSelected)
            {
                //segue to username selection
            }
            else //Not authorized, show sign in and create account buttons
            {
                self.showInterface()
                //hide activity indicator
            }
        }
        
    }
    
    private func hideInterface()
    {
        ActivityIndicator.hidden = false
        ActivityIndicator.startAnimating()
        CreateAccountButton.hidden = true
        SignInButton.hidden = true
    }
    
    private func showInterface()
    {
        ActivityIndicator.hidden = true
        ActivityIndicator.stopAnimating()
        CreateAccountButton.hidden = false
        SignInButton.hidden = false
    }
    
}
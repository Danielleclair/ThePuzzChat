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
    
    var authStatusFetched = false
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        if !authStatusFetched {
            hideInterface()
        }
    }
    
    override func viewDidLoad() {
        //Check authorization status
        FirebaseManager.sharedInstance.GetUserAuthState { [weak self] (authorized, usernameSelected) in
            
            self?.authStatusFetched = true
            self?.showInterface()
            if (authorized && usernameSelected)
            {
                self?.performSegue(withIdentifier: "userAuthSegue", sender: nil)
                self?.showInterface()
            }
            else if (authorized && !usernameSelected)
            {
                self?.performSegue(withIdentifier: "createPuzzatar", sender: nil)
            }
            else //Not authorized, show sign in and create account buttons
            {
                self?.showInterface()
                //hide activity indicator
            }
 
        }
    }
    
    fileprivate func hideInterface()
    {
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
        CreateAccountButton.isHidden = true
        SignInButton.isHidden = true
    }
    
    fileprivate func showInterface()
    {
        ActivityIndicator.isHidden = true
        ActivityIndicator.stopAnimating()
        CreateAccountButton.isHidden = false
        SignInButton.isHidden = false
    }
    
}

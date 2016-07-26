//
//  LandingPageVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class LandingPageVC: UIViewController
{
    override func viewDidLoad() {
        
        //Hide buttons
        //Show activity indicator
        
        //Check authorization status
        FirebaseManager.sharedInstance.GetUserAuthState { (authorized, usernameSelected) in
         
            if (authorized && usernameSelected)
            {
                //segue to home screen
            }
            else if (authorized && !usernameSelected)
            {
                //segue to username selection
            }
            else //Not authorized, show sign in and create account buttons
            {
                //Show buttons
                //hide activity indicator
            }
        }
        
    }
    
}
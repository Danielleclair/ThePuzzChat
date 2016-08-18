//
//  AccountVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/27/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class AccountVC: UIViewController
{
    @IBAction func SignOut() {
        FirebaseManager.sharedInstance.SignOut()
    }
   
    override func viewDidLoad() {
        
    }
}
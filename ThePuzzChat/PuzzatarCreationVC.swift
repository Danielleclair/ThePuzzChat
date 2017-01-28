//
//  PuzzatarCreationVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class PuzzatarCreationVC: UIViewController
{
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBAction func CreateUserAccount(_ sender: AnyObject) {
        
        if (UsernameTextField.text != nil)
        {
            FirebaseManager.sharedInstance.AddNewUser(UsernameTextField.text!, callback: { (success) in
                
                if (success)
                {
                    
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "HomeScreenSegue", sender: nil)
                    })
                }
            })
        }
    }
}

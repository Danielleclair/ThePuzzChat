//
//  TestVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class TestVC: UIViewController
{
    
    @IBAction func SendMessage(sender: AnyObject) {
        
        FirebaseManager.sharedInstance.SendPuzzchat("123456789")
    }
}
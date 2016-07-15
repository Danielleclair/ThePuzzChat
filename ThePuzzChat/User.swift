//
//  User.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/15/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation

class User: NSObject
{
    static let sharedInstance = User()
    
    private override init()
    {
        
    }
    
    var email: String?
    var userName: String?
}
//
//  User.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/15/16.
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
    var userID: String?
    var friendsList: [String : String] = [:]
}
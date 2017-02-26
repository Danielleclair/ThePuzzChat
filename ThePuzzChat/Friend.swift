//
//  Friend.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/20/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation

class Friend: NSObject
{
    let userID: String
    let userName: String
    let requestAccepted: Int
    
    init(_userID: String, _userName: String, _requestAccepted: Int) {
        userID = _userID
        userName = _userName
        requestAccepted = _requestAccepted
    }
}

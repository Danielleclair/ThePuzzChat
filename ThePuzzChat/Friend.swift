//
//  Friend.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/20/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation

class Friend: NSObject
{
    let userID: String
    let userName: String
    let requestAccepted: Bool
    
    init(_userID: String, _userName: String, _requestAccepted: Bool) {
        userID = _userID
        userName = _userName
        requestAccepted = _requestAccepted
    }
}
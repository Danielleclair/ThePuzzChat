//
//  Friend.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/20/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation

struct Friend
{
    enum RequestStatus: Int {
        case pending = 0
        case accepted
        case declined
        case awaitingResponse
    }
    
    let userID: String?
    let userName: String
    let requestAccepted: RequestStatus
    
    init(userID: String? = nil, userName: String, requestAccepted: Int) {
        self.userID = userID
        self.userName = userName
        self.requestAccepted = RequestStatus(rawValue: requestAccepted) ?? .declined
    }
}

//
//  Message.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/18/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation

class Message: NSObject
{
    let fromUserID: String
    let fromUserName: String
    //let image: UIImage?
    let message: String
    let sendDate: NSDate
    let puzzleSize: Int
    
    init(_fromUserID: String, _fromUserName: String, _message: String, _sendDate: NSDate, _puzzleSize: Int)
    {
        fromUserID = _fromUserID
        fromUserName = _fromUserName
        message = _message
        sendDate = _sendDate
        puzzleSize = _puzzleSize
    }
    
}
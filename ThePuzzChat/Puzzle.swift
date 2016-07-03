//
//  Puzzle.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/3/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class Puzzle: NSObject
{
    //Dimmensions of the puzzle between 3 and 10, always square
    var dimmension: Int?
    var image: UIImage?
    
    init(_dimmension: Int, _image: UIImage) {
        dimmension = _dimmension
        image = _image
    }
}
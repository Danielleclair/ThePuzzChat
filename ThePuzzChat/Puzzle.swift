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
    //dimensions of the puzzle between 3 and 10, always square
    let dimension: Int
    let image: UIImage
    var timer: NSTimer?
    
    init(_dimension: Int, _image: UIImage) {
        dimension = _dimension
        image = _image
    }
}
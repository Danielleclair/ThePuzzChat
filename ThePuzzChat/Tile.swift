//
//  Tile.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/3/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

typealias Coordinate = (Int, Int)

class Tile: NSObject
{
    let Image: UIImage?
    let CorrectPosition: Coordinate? //Where the piece should be when the puzzle is complete
    
    var CurrentPosition: Coordinate? //Where the piece is currently
    
    
    
    init(_image: UIImage, _correctPosition: Coordinate) {
        Image = _image
        CorrectPosition = _correctPosition
    }
}
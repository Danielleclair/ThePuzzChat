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
    var Image: UIImageView?
    
    var isBlank = false
    
    let CorrectPosition: Coordinate //Where the piece should be when the puzzle is complete
    var CurrentPosition: Coordinate //Where the piece is currently
    
    //Tiles are created with their current position being the correct position
    init(_imageView: UIImageView, _correctPosition: Coordinate) {
        Image = _imageView
        CorrectPosition = _correctPosition
        CurrentPosition = _correctPosition
    }
}
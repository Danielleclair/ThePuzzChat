//
//  Puzzle.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/3/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

enum Direction
{
    case Up
    case Down
    case Left
    case Right
}

class Puzzle: NSObject
{
    //dimensions of the puzzle between 3 and 10, always square
    let dimension: Int
    var tiles : [Tile?] //Hash table of tiles indexed by their view tag
    var puzzle = [[Tile?]]()
    var grid = [[Tile?]]()
    let image: UIImage
    var timer: NSTimer?
    var timerSeconds: Int
    var delegate: UIViewController
    
    //--------------------------------------------------------------------------
    //Constructor
    //--------------------------------------------------------------------------
    init(_dimension: Int, _image: UIImage, secondsCompletionTime: Int, _delegate: UIViewController) {
        
        delegate = _delegate
        dimension = _dimension
        timerSeconds = secondsCompletionTime
        image = _image
        
        //Create default arrays
        tiles = [Tile?](count: (dimension * dimension), repeatedValue: nil)
        
        for _ in 0..<dimension
        {
            puzzle.append([Tile?](count: dimension, repeatedValue: nil))
        }
        
        super.init()
    
        //Get the height & width of each tile by breaking the total size by
        //the number of tiles
        let tileWidth = image.size.width / CGFloat(dimension)
        let tileHeight = image.size.height / CGFloat(dimension)
        
        //Width
        for i in 0..<dimension
        {
            //Height
            for j in 0..<dimension
            {
                //Create the position of the new image
                let imagePositioning = CGRectMake(tileWidth * CGFloat(i), tileHeight * CGFloat(j), tileWidth, tileHeight)
                
                let tileImage = CGImageCreateWithImageInRect(image.CGImage, imagePositioning)
                
                var imgView: UIImageView
                
                if(i == 0 && j == 0)
                {
                    imgView = UIImageView()
                }
                else
                {
                    let img = UIImage(CGImage: tileImage!)
                    imgView = UIImageView(image: img)
                }
                
                imgView.tag = (i + (j * dimension))
                imgView.userInteractionEnabled = true
                addSwipeGestureRecognizerToImage(imgView)
                
                //Create the correct coordinate
                let coordinate = Coordinate(i, j)
                
                //Create the new tile
                let tile = Tile(_imageView: imgView, _correctPosition: coordinate)
        
                if (i == 0 && j == 0)
                {
                    tile.isBlank = true
                }
                
            
                puzzle[i][j] = tile
                tiles[imgView.tag] = tile
            
                imgView.layer.borderWidth = 1.0
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //Shuffle puzzle pieces to create a new permutation
    //--------------------------------------------------------------------------
    func Shuffle()
    {
        for i in 0..<tiles.count
        {
            let rand = Int((arc4random_uniform(UInt32(tiles.count - 1))))
            
            swapTile(&tiles[i]!, withTile: &tiles[rand]!)
        }
    }
    
    //------------------------------------------------------------------------------------------
    //Add the swipe gesture recognizers to the image view
    //------------------------------------------------------------------------------------------
    private func addSwipeGestureRecognizerToImage(imgView: UIImageView)
    {
        let directions: [UISwipeGestureRecognizerDirection] = [.Up, .Down, .Right, .Left]
        for direction in directions
        {
            let swipeRecognizer = UISwipeGestureRecognizer()
            swipeRecognizer.direction = direction
            swipeRecognizer.addTarget(delegate, action: #selector(SolvePuzzleVC.tileWasSwiped))
            imgView.addGestureRecognizer(swipeRecognizer)
        }
    }

    
    //--------------------------------------------------------------------------
    //Updates the puzzle by moving the tile with the given tag in a direction.
    //Return true on success, false if move cannot be made.
    //--------------------------------------------------------------------------
    func SlideTileWithTag(tag: Int, direction: Direction) -> Bool
    {
        //Check that the tile exists
        if (tag >= tiles.count || tiles[tag] == nil)
        {
            return false
        }
        
        let tile = tiles[tag]!
        
        //Check to make sure tile isn't already at the top of the puzzle
        if (direction == .Up && tile.CurrentPosition.1 != 0)
        {
            //Check to see if there is space to move the piece into, and that the piece selected to move exists
            if(puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1 - 1]!.isBlank && !puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!.isBlank)
            {
                
                swapTile(&puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1 - 1]!, withTile: &puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!)

                return true

            }
            else //No space
            {
                return false
            }
        }
        else if (direction == .Down && tile.CurrentPosition.1 < dimension)
        {
            //Check to see if there is space to move the piece into, and that the piece selected to move exists
            if(puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1 + 1]!.isBlank && !puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!.isBlank)
            {
                
                swapTile(&puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1 + 1]!, withTile: &puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!)
                
                return true
                
            }
            else //No space
            {
                return false
            }
        }
        else if (direction == .Left && tile.CurrentPosition.0 != 0)
        {
            //Check to see if there is space to move the piece into, and that the piece selected to move exists
            if(puzzle[tile.CurrentPosition.0 - 1][tile.CurrentPosition.1]!.isBlank && !puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!.isBlank)
            {
                
                swapTile(&puzzle[tile.CurrentPosition.0 - 1][tile.CurrentPosition.1]!, withTile: &puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!)
                
                return true
                
            }
            else //No space
            {
                return false
            }
        }
        else if (direction == .Right && tile.CurrentPosition.0 < dimension)
        {
            //Check to see if there is space to move the piece into, and that the piece selected to move exists
            if(puzzle[tile.CurrentPosition.0 + 1][tile.CurrentPosition.1]!.isBlank && !puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!.isBlank)
            {
                
                swapTile(&puzzle[tile.CurrentPosition.0 + 1][tile.CurrentPosition.1]!, withTile: &puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1]!)
                
                return true
                
            }
            else //No space
            {
                return false
            }
        }
        return false
    }
    
    private func swapTile(inout tile: Tile, inout withTile: Tile)
    {
        //Disallow swaps of the same element
        if (tile.CurrentPosition != withTile.CurrentPosition)
        {
            swap(&puzzle[tile.CurrentPosition.0][tile.CurrentPosition.1], &puzzle[withTile.CurrentPosition.0][withTile.CurrentPosition.1])
            
            //Swap the current positions in the hash table
            let randTileCords = withTile.CurrentPosition
            let iTileCords = tile.CurrentPosition
            withTile.CurrentPosition = iTileCords
            tile.CurrentPosition = randTileCords
        }

    }
    
   

}
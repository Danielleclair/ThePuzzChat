//
//  SolvePuzzleVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/3/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class SolvePuzzleVC: UIViewController
{
    
    var puzzle: Puzzle?
    
    override func viewDidLoad() {
    
        puzzle = Puzzle(_dimension: 5, _image: UIImage(named: "PuzzchatIcon.png")!, secondsCompletionTime: 60)
        DisplayPuzzle(puzzle!)
        
    }
    
    @IBOutlet weak var horizontalStack: UIStackView!
    @IBAction func Display(sender: AnyObject) {
        DisplayPuzzle(puzzle!)
    }
    
    @IBAction func shuffle(sender: AnyObject) {
        puzzle!.Shuffle()
    }
    func DisplayPuzzle(puzzle: Puzzle)
    {
        //Remove any old views
        for column in horizontalStack.arrangedSubviews
        {
            column.removeFromSuperview()
        }
        
        //Width
        for i in 0..<puzzle.dimension
        {
            let verticalStack = UIStackView()
            verticalStack.axis = .Vertical
            verticalStack.alignment = .Fill
            verticalStack.distribution = .FillEqually
            
            //Height
            for j in 0..<puzzle.dimension
            {
                let tile = puzzle.puzzle[i][j]
                if (tile != nil)
                {
                    if (tile!.isBlank == true)
                    {
                        verticalStack.addArrangedSubview(UIView())
                    }
                    else if (tile!.Image != nil)
                    {
                        addSwipeGestureRecognizerToImage(tile!.Image!)
                        verticalStack.addArrangedSubview(tile!.Image!)
                    }
                }
                else //This is the blank piece
                {
                    
                }
            }

            horizontalStack.addArrangedSubview(verticalStack)
        }
    }
    
    /*
    //Sets up the puzzle in the view
    func CreatePuzzle(inout puzzle: Puzzle)
    {
            //Get the height & width of each tile by breaking the total size by
            //the number of tiles
            print(puzzle.image.size.width)
            print(puzzle.image.size.height)
        
            let tileWidth = puzzle.image.size.width / CGFloat(puzzle.dimension)
            let tileHeight = puzzle.image.size.height / CGFloat(puzzle.dimension)
        
            print(tileWidth)
            print(tileHeight)
            
            //Width
            for i in 0..<puzzle.dimension
            {
                let verticalStack = UIStackView()
                verticalStack.axis = .Vertical
                verticalStack.alignment = .Fill
                verticalStack.distribution = .FillEqually
                
                //Height
                for j in 0..<puzzle.dimension
                {
                    
                    //Create the position of the new image
                    let imagePositioning = CGRectMake(tileWidth * CGFloat(i), tileHeight * CGFloat(j), tileWidth, tileHeight)
                    
                    let tileImage = CGImageCreateWithImageInRect(puzzle.image.CGImage, imagePositioning)
                    
                    let img = UIImage(CGImage: tileImage!)
                    let imgView = UIImageView(image: img)
                    imgView.tag = (i + (j * puzzle.dimension))
                    imgView.userInteractionEnabled = true
                    
                    addSwipeGestureRecognizerToImage(imgView)
                    
                    //Create the correct coordinate
                    let coordinate = Coordinate(i, j)
                    
                    //Create the new tile
                    let tile = Tile(_imageView: imgView, _correctPosition: coordinate)
                    
                    if (imgView.tag < puzzle.tiles.count)
                    {
                        puzzle.tiles[imgView.tag] = tile
                    }
                    
                    imgView.layer.borderWidth = 1.0
                    
                    verticalStack.addArrangedSubview(imgView)
                }
                
                horizontalStack.addArrangedSubview(verticalStack)
            }
    }
 */
 
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
            swipeRecognizer.addTarget(self, action: #selector(SolvePuzzleVC.tileWasSwiped))
            imgView.addGestureRecognizer(swipeRecognizer)
        }
    }
    
    //------------------------------------------------------------------------------------------
    //Called when a tile is swiped
    //------------------------------------------------------------------------------------------
    func tileWasSwiped(swipeRecognizer: UISwipeGestureRecognizer)
    {
        if (swipeRecognizer.view != nil && puzzle != nil)
        {
            if (swipeRecognizer.direction == .Up)
            {
               
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Up)
                DisplayPuzzle(puzzle!)
            }
            if (swipeRecognizer.direction == .Down)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Down)
                DisplayPuzzle(puzzle!)
            }
            if (swipeRecognizer.direction == .Left)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Left)
                DisplayPuzzle(puzzle!)
            }
            if (swipeRecognizer.direction == .Right)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Right)
                DisplayPuzzle(puzzle!)
            }
        }
    }
    
    
    
    
    
    
}

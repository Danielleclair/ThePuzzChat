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
    var images: [UIImageView] = []
    
    override func viewDidLoad() {
    
        puzzle = Puzzle(_dimension: 5, _image: UIImage(named: "PuzzchatIcon.png")!, secondsCompletionTime: 60)
        
        /*
        for i in 0...10000000
        {
            DisplayPuzzle()
        }
*/
        
    }
    
    @IBOutlet weak var horizontalStack: UIStackView!
    
    @IBAction func Display(sender: AnyObject) {
        updatePuzzleView()
    }
    
    @IBAction func shuffle(sender: AnyObject) {
       // puzzle!.Shuffle()
        DisplayPuzzle()
    }
    
    
    
    func DisplayPuzzle()
    {
        
        //Remove any old views
        for column in horizontalStack.arrangedSubviews as! [UIStackView]
        {
            for row in column.arrangedSubviews
            {
                horizontalStack.removeArrangedSubview(row)
                row.removeFromSuperview()
            }
            horizontalStack.removeArrangedSubview(column)
            column.removeFromSuperview()
        }

        //Width
        for i in 0..<puzzle!.dimension
        {
            let verticalStack = UIStackView()
            verticalStack.axis = .Vertical
            verticalStack.alignment = .Fill
            verticalStack.distribution = .FillEqually
            
            //Height
            for j in 0..<puzzle!.dimension
            {
                if (puzzle!.puzzle[i][j] != nil)
                {
                    if (puzzle!.puzzle[i][j]!.isBlank == true)
                    {
                        verticalStack.addArrangedSubview(UIView())
                    }
                    else if (puzzle!.puzzle[i][j]!.Image != nil)
                    {
                        // addSwipeGestureRecognizerToImage(puzzle!.puzzle[i][j]!.Image!)
                        verticalStack.addArrangedSubview(puzzle!.puzzle[i][j]!.Image!)
                    }
                }
                else //This is the blank piece
                {
                    
                }
            }
            
            horizontalStack.addArrangedSubview(verticalStack)
        }
 
    }
    
    private func updatePuzzleView()
    {
      puzzle?.puzzle[1][1]!.Image = UIImageView(image: UIImage(named: "Daniel"))
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
            swipeRecognizer.addTarget(self, action: #selector(SolvePuzzleVC.tileWasSwiped))
            imgView.addGestureRecognizer(swipeRecognizer)
        }
    }
    
    private func removeSwipeGestureRecognizerFromImage(imgView: UIImageView)
    {
        let directions: [UISwipeGestureRecognizerDirection] = [.Up, .Down, .Right, .Left]
        for direction in directions
        {
            let swipeRecognizer = UISwipeGestureRecognizer()
            swipeRecognizer.direction = direction
            swipeRecognizer.addTarget(self, action: #selector(SolvePuzzleVC.tileWasSwiped))
            imgView.removeGestureRecognizer(swipeRecognizer)
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
                DisplayPuzzle()
            }
            if (swipeRecognizer.direction == .Down)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Down)
                DisplayPuzzle()
            }
            if (swipeRecognizer.direction == .Left)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Left)
                DisplayPuzzle()
            }
            if (swipeRecognizer.direction == .Right)
            {
                puzzle!.SlideTileWithTag(swipeRecognizer.view!.tag, direction: .Right)
                DisplayPuzzle()
            }
        }
    }
    
    
    
    
    
    
}

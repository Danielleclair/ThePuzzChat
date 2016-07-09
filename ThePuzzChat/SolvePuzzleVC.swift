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

        puzzle = Puzzle(_dimension: 3, _image: UIImage(named: "PuzzchatIcon.png")!, secondsCompletionTime: 60, _delegate: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        DisplayPuzzle()
    }
    
    @IBOutlet weak var puzzleView: UIView!
    
    
    @IBAction func shuffle(sender: AnyObject) {
        puzzle!.Shuffle()
        DisplayPuzzle()
    }
    
    
    
    func DisplayPuzzle()
    {
        if (puzzle != nil)
        {
            //Get the size of the view
            let viewHeight = puzzleView.frame.size.height
            let viewWidth = puzzleView.frame.size.width
        
            //Get the size of the tiles
            let tileHeight = (viewHeight / CGFloat(puzzle!.dimension))
            let tileWidth = (viewWidth / CGFloat(puzzle!.dimension))
            
            for i in 0..<puzzle!.dimension
            {
                for j in 0..<puzzle!.dimension
                {
                    if let img = puzzle!.puzzle[i][j]!.Image
                    {
                            img.frame = CGRect(x: tileWidth * CGFloat(i), y: tileHeight * CGFloat(j), width: tileWidth, height: tileHeight)
                            puzzleView.addSubview(img)
                    }
                }
            }
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

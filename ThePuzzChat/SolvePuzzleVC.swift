//
//  SolvePuzzleVC.swift
//  ThePuzzChat
//
//  Created by Daniel Rosaia on 7/3/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class SolvePuzzleVC: UIViewController
{
    
    @IBOutlet weak var horizontalStack: UIStackView!
    
    //Sets up the puzzle in the view
    func CreatePuzzle(puzzle: Puzzle)
    {
        //Create the image grid
        if (puzzle.dimmension != nil)
        {
            //Width
            for var i in 0...puzzle.dimmension!
            {
                let verticalStack = UIStackView()
                verticalStack.axis = .Vertical
                
                //Height
                for var j in 0...puzzle.dimmension!
                {
                    
                }
            }
        }
        else
        {
            //Error - Puzzle has no dimmension
        }
      
    }
}

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
    
    override func viewDidLoad() {
        
        let p = Puzzle(_dimension: 4, _image: UIImage(named: "Robot.png")!)
        
        CreatePuzzle(p)
    }
    
    @IBOutlet weak var horizontalStack: UIStackView!
    
    //Sets up the puzzle in the view
    func CreatePuzzle(puzzle: Puzzle)
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
                    
                    let image = UIImage(named: "Robot")?.CGImage!
                        //puzzle.image.CGImage
                    
                    let tileImage = CGImageCreateWithImageInRect(image, imagePositioning)
                    
                    print("(\(i),\(j))")
                    
                    let img = UIImage(CGImage: tileImage!)
                    let imgView = UIImageView(image: img)
                    imgView.layer.borderWidth = 1.0
                    
                    
                    verticalStack.addArrangedSubview(imgView)
                }
                
                horizontalStack.addArrangedSubview(verticalStack)
            }
    }
}

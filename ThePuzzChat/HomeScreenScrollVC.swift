//
//  HomeScreenScrollVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/9/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenScrollVC: UIViewController
{
    
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    override func viewDidLoad() {
        
        let puzzVC = UIViewController(nibName: "PuzzVC", bundle: nil)
        
        self.addChildViewController(puzzVC)
        self.scrollView.addSubview(puzzVC.view)
        puzzVC.didMoveToParentViewController(self)
        
        let storeVC = UIViewController(nibName: "StoreVC", bundle: nil)
        
        var storeFrame = storeVC.view.frame
        storeFrame.origin.x = self.view.frame.width
        storeVC.view.frame = storeFrame
        
        self.addChildViewController(storeVC)
        self.scrollView.addSubview(storeVC.view)
        storeVC.didMoveToParentViewController(self)
        
        let friendsVC = UIViewController(nibName: "FriendsVC", bundle: nil)
        
        var friendsFrame = friendsVC.view.frame
        friendsFrame.origin.x = self.view.frame.width * 2
        friendsVC.view.frame = friendsFrame
        
        self.addChildViewController(friendsVC)
        self.scrollView.addSubview(friendsVC.view)
        storeVC.didMoveToParentViewController(self)
        
        let accountVC = UIViewController(nibName: "AccountVC", bundle: nil)
        
        var accountFrame = accountVC.view.frame
        accountFrame.origin.x = self.view.frame.width * 3
        accountVC.view.frame = accountFrame
        
        self.addChildViewController(accountVC)
        self.scrollView.addSubview(accountVC.view)
        storeVC.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height)
        
        let puzzButton = UIButton()
        puzzButton.setImage(UIImage(named: "PuzzIcon"), forState: .Normal)
        horizontalStackView.addArrangedSubview(puzzButton)
        
        let storeButton = UIButton()
        puzzButton.setImage(UIImage(named: "StoreTab"), forState: .Normal)
        horizontalStackView.addArrangedSubview(storeButton)
        
        let newPuzzButton = UIButton()
        puzzButton.setImage(UIImage(named: "CreateNewPuzz"), forState: .Normal)
        horizontalStackView.addArrangedSubview(newPuzzButton)

        let friendsButton = UIButton()
        puzzButton.setImage(UIImage(named: "FriendsIcon"), forState: .Normal)
        horizontalStackView.addArrangedSubview(friendsButton)
        
        let accountButton = UIButton()
        accountButton.setImage(UIImage(named: "AccountIcon"), forState: .Normal)
        horizontalStackView.addArrangedSubview(accountButton)

    }
    
   
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
}
//
//  HomeScreenScrollVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/9/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenScrollVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var selectedIndex = 0
    var tabButtons: [UIButton] = []
    
    @IBOutlet weak var tabBar: UIView!
    
    override func viewDidLoad() {
        
        //scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        //let puzzVC = self.storyboard!.instantiateViewControllerWithIdentifier("Test")
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
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let puzzButton = UIButton(frame: CGRectMake(0, 0, tabBar.frame.width / 5, tabBar.frame.height))
        puzzButton.setImage(UIImage(named: "PuzzIconSelected"), forState: .Normal)
        puzzButton.addTarget(self, action: #selector(HomeScreenScrollVC.navigateToPuzzView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(puzzButton)
        tabButtons += [puzzButton]
        
        let friendsButton = UIButton(frame: CGRectMake(tabBar.frame.width / 5, 0, tabBar.frame.width / 5, tabBar.frame.height))
        friendsButton.setImage(UIImage(named: "FriendsIconSelected"), forState: .Normal)
        friendsButton.addTarget(self, action: #selector(HomeScreenScrollVC.navigateToFriendsView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(friendsButton)
        tabButtons += [friendsButton]
         
        let newPuzzButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 2, 0, tabBar.frame.width / 5, tabBar.frame.height))
        newPuzzButton.setImage(UIImage(named: "CreateNewPuzz"), forState: .Normal)
        newPuzzButton.addTarget(self, action: #selector(HomeScreenScrollVC.CreateNewPuzz), forControlEvents: .TouchUpInside)
        tabBar.addSubview(newPuzzButton)
        tabButtons += [newPuzzButton]
         
        let storeButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 3, 0, tabBar.frame.width / 5, tabBar.frame.height))
        storeButton.setImage(UIImage(named: "StoreTabSelected"), forState: .Normal)
        storeButton.addTarget(self, action: #selector(HomeScreenScrollVC.navigateToStoreView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(storeButton)
        tabButtons += [storeButton]
         
        let accountButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 4, 0, tabBar.frame.width / 5, tabBar.frame.height))
        accountButton.setImage(UIImage(named: "AccountIconSelected"), forState: .Normal)
        accountButton.addTarget(self, action: #selector(HomeScreenScrollVC.navigateToAccountView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(accountButton)
        tabButtons += [accountButton]
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height)
    }
    
    func navigateToPuzzView()
    {
        scrollToPage(0)
    }
    
    func navigateToFriendsView()
    {
        scrollToPage(1)
    }
    
    func navigateToStoreView()
    {
        scrollToPage(2)
    }
    
    func navigateToAccountView()
    {
        scrollToPage(3)
    }
    
    private func scrollToPage(pageNumber: Int)
    {
        scrollView.contentOffset = CGPointMake(self.view.frame.width * CGFloat(pageNumber), 0)
    }
    
    func CreateNewPuzz()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
        
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            

            
            var overlayFrame = imagePicker.view.bounds
            UIGraphicsBeginImageContext(overlayFrame.size)
            UIRectFillUsingBlendMode(CGRectMake(0, imagePicker.navigationBar.bounds.size.height, overlayFrame.size.width, 300), .Normal);
            
            let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let overlay = UIImageView(frame: overlayFrame)
            overlay.image = overlayImage
            overlay.alpha = 1.0
            imagePicker.cameraOverlayView = overlay
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
   
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
}
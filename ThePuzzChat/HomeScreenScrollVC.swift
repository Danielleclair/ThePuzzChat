//
//  HomeScreenScrollVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/9/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenVC: UIPageViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPageViewControllerDataSource
{
    var selectedIndex = 0
    var tabButtons: [UIButton] = []
    var views: [UIViewController] = []
    
  //  @IBOutlet weak var tabBar: UIView!
    
    override func viewDidLoad() {
        
        
        dataSource = self
        
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PuzzView")]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FriendsView")]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StoreView")]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AccountView")]
        
        setViewControllers(([views.first!]), direction: .Forward, animated: false, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let indexOfCurrentView = views.indexOf(viewController)
        {
            let indexBeforeCurrentView = indexOfCurrentView - 1
            
            if (indexBeforeCurrentView < 0)
            {
                return nil
            }
            else
            {
                return views[indexBeforeCurrentView]
            }
        }
        else
        {
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let indexOfCurrentView = views.indexOf(viewController)
        {
            let indexAfterCurrentView = indexOfCurrentView + 1
            
            if (indexAfterCurrentView == views.count)
            {
                return nil
            }
            else
            {
                return views[indexAfterCurrentView]
            }
        }
        else
        {
            return nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        let tabBarHeight = viewHeight / 10
        let accountBarHeight = viewHeight / 20
        
        let tabBar = UIView(frame: CGRectMake(0, viewHeight - tabBarHeight, viewWidth, tabBarHeight))
        let accountBar = UIView(frame: CGRectMake(0, 20, viewWidth, accountBarHeight))
        
        tabBar.backgroundColor = UIColor.darkGrayColor()
        
        self.view.addSubview(tabBar)
        self.view.addSubview(accountBar)
        
        let puzzPoint = UIImageView(image: UIImage(named: "PuzzPoint"))
        puzzPoint.frame = CGRectMake(viewWidth / 25, 0, accountBarHeight, accountBarHeight)
        accountBar.addSubview(puzzPoint)
        
        let puzzPointLabel = UILabel(frame: CGRectMake((viewWidth / 25) + accountBarHeight, 0, viewWidth / 4, accountBarHeight))
        puzzPointLabel.text = "1000"
        puzzPointLabel.textColor = UIColor.whiteColor()
        accountBar.addSubview(puzzPointLabel)
     
        let puzzButton = UIButton(frame: CGRectMake(0, 0, tabBar.frame.width / 5, tabBar.frame.height))
        puzzButton.setImage(UIImage(named: "PuzzIconSelected"), forState: .Normal)
        puzzButton.addTarget(self, action: #selector(HomeScreenVC.navigateToPuzzView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(puzzButton)
        tabButtons += [puzzButton]
        
        let friendsButton = UIButton(frame: CGRectMake(tabBar.frame.width / 5, 0, tabBar.frame.width / 5, tabBar.frame.height))
        friendsButton.setImage(UIImage(named: "FriendsIconSelected"), forState: .Normal)
        friendsButton.addTarget(self, action: #selector(HomeScreenVC.navigateToFriendsView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(friendsButton)
        tabButtons += [friendsButton]
         
        let newPuzzButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 2, 0, tabBar.frame.width / 5, tabBar.frame.height))
        newPuzzButton.setImage(UIImage(named: "CreateNewPuzz"), forState: .Normal)
        newPuzzButton.addTarget(self, action: #selector(HomeScreenVC.CreateNewPuzz), forControlEvents: .TouchUpInside)
        tabBar.addSubview(newPuzzButton)
        tabButtons += [newPuzzButton]
         
        let storeButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 3, 0, tabBar.frame.width / 5, tabBar.frame.height))
        storeButton.setImage(UIImage(named: "StoreTabSelected"), forState: .Normal)
        storeButton.addTarget(self, action: #selector(HomeScreenVC.navigateToStoreView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(storeButton)
        tabButtons += [storeButton]
         
        let accountButton = UIButton(frame: CGRectMake((tabBar.frame.width / 5) * 4, 0, tabBar.frame.width / 5, tabBar.frame.height))
        accountButton.setImage(UIImage(named: "AccountIconSelected"), forState: .Normal)
        accountButton.addTarget(self, action: #selector(HomeScreenVC.navigateToAccountView), forControlEvents: .TouchUpInside)
        tabBar.addSubview(accountButton)
        tabButtons += [accountButton]
    }
    
    func navigateToPuzzView()
    {
        setViewControllers(([views[0]]), direction: .Forward, animated: false, completion: nil)
    }
    
    func navigateToFriendsView()
    {
        setViewControllers(([views[1]]), direction: .Forward, animated: false, completion: nil)
    }
    
    func navigateToStoreView()
    {
        setViewControllers(([views[2]]), direction: .Forward, animated: false, completion: nil)
    }
    
    func navigateToAccountView()
    {
        setViewControllers(([views[3]]), direction: .Forward, animated: false, completion: nil)
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
   
    
    
}
//
//  HomeScreenScrollVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/9/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenVC: UIPageViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPageViewControllerDataSource
{
    
    private struct Constants {
        static let tabBarHeight: CGFloat = 50.0
    }
    
    let tabBar = UIView()
    let accountBar = UIView()
    
    private enum Views: Int {
        case PuzzView = 0
        case FriendsView
        case StoreView
        case AccountView
        case CreatePuzzView
        
        var storyboardID: String {
            switch self {
            case .PuzzView: return "PuzzView"
            case .FriendsView: return "FriendsView"
            case .StoreView: return "StoreView"
            case .AccountView: return "AccountView"
            case .CreatePuzzView: return "CreatePuzzView:"
            }
        }
        
        var iconName: String {
            switch self {
            case .PuzzView: return "PuzzIconSelected"
            case .FriendsView: return "FriendIconSelected"
            case .StoreView: return "StoreTabSelected"
            case .AccountView: return "AccountIconSelected"
            case .CreatePuzzView: return "CreateNewPuzz"
            }
        }
        
        var navigationAction: Selector {
            switch self {
            case .PuzzView: return #selector(navigateToPuzzView)
            case .FriendsView: return #selector(navigateToFriendsView)
            case .StoreView: return #selector(navigateToStoreView)
            case .AccountView: return #selector(navigateToAccountView)
            case .CreatePuzzView: return #selector(navigateToCreatePuzzView)
            }
        }
    }
    
    var selectedIndex = 0
    var tabButtons: [UIButton] = []
    var views: [UIViewController] = []
    
    override func viewDidLoad() {
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        let accountBarHeight = viewHeight / 20
        let accountBar = UIView(frame: CGRect(x: 0, y: 20, width: viewWidth, height: accountBarHeight))
        
        tabBar.backgroundColor = UIColor.darkGray
        
        self.view.addSubview(tabBar)
        self.view.addSubview(accountBar)
        
        let puzzPoint = UIImageView(image: UIImage(named: "PuzzPoint"))
        puzzPoint.frame = CGRect(x: viewWidth / 25, y: 0, width: accountBarHeight, height: accountBarHeight)
        accountBar.addSubview(puzzPoint)
        
        let puzzPointLabel = UILabel(frame: CGRect(x: (viewWidth / 25) + accountBarHeight, y: 0, width: viewWidth / 4, height: accountBarHeight))
        puzzPointLabel.text = "1000"
        puzzPointLabel.textColor = UIColor.white
        accountBar.addSubview(puzzPointLabel)
        
        configureTabBar()
    }
    
    // MARK: Page view controller methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentView = views.index(of: viewController) else { return nil }
        let indexBeforeCurrentView = indexOfCurrentView - 1
        guard indexBeforeCurrentView > 0 else { return nil }
        return views[indexBeforeCurrentView]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentView = views.index(of: viewController) else { return nil }
        let indexAfterCurrentView = indexOfCurrentView + 1
        guard indexAfterCurrentView < views.count else { return nil }
        return views[indexAfterCurrentView]
    }
    
    // MARK: Helper methods
    
    private func createHomeScreenViews() {
        
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Views.PuzzView.storyboardID)]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Views.FriendsView.storyboardID)]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Views.StoreView.storyboardID)]
        views += [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Views.AccountView.storyboardID)]
        
        guard let initialView = views.first else { return }
        
        setViewControllers(([initialView]), direction: .forward, animated: false, completion: nil)
    }
    
    private func navigate(toView view: Views) {
        guard views.count > view.rawValue else { return }
        setViewControllers([views[view.rawValue]], direction: .forward, animated: false, completion: nil)
    }
    
    private func createHomeViewNavigationButton(withFrame frame: CGRect, view: Views) {
        let navigationButton = UIButton(frame: frame)
        navigationButton.setImage(UIImage(named: view.iconName), for: .normal)
        navigationButton.addTarget(self, action: view.navigationAction, for: .touchUpInside)
        tabBar.addSubview(navigationButton)
        tabButtons += [navigationButton]
    }
    
    private func configureNavigationButtons() {
        createHomeViewNavigationButton(withFrame: CGRect(x: 0, y: 0, width: tabBar.frame.width / 5, height: tabBar.frame.height), view: .PuzzView)
        createHomeViewNavigationButton(withFrame: CGRect(x: tabBar.frame.width / 5, y: 0, width: tabBar.frame.width / 5, height: tabBar.frame.height), view: .FriendsView)
        createHomeViewNavigationButton(withFrame: CGRect(x: (tabBar.frame.width / 5) * 2, y: 0, width: tabBar.frame.width / 5, height: tabBar.frame.height), view: .CreatePuzzView)
        createHomeViewNavigationButton(withFrame: CGRect(x: (tabBar.frame.width / 5) * 3, y: 0, width: tabBar.frame.width / 5, height: tabBar.frame.height), view: .StoreView)
        createHomeViewNavigationButton(withFrame: CGRect(x: (tabBar.frame.width / 5) * 4, y: 0, width: tabBar.frame.width / 5, height: tabBar.frame.height), view: .AccountView)
    }
    
    private func configureTabBar() {
        let heightConstraint = tabBar.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight)
        let leadingAnchor = tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingAnchor = tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        
        NSLayoutConstraint.activate([heightConstraint, leadingAnchor, trailingAnchor])
        configureNavigationButtons()
    }
    
    // MARK: Target / action methods
    
    func navigateToPuzzView() {
        navigate(toView: .PuzzView)
    }
    
    func navigateToFriendsView() {
        navigate(toView: .FriendsView)
    }
    
    func navigateToStoreView() {
        navigate(toView: .StoreView)
    }
    
    func navigateToAccountView() {
        navigate(toView: .AccountView)
    }
    
    func navigateToCreatePuzzView() { // TODO: Implement
        
    }
    
    func CreateNewPuzz() { // TODO: Move to the create puzz controller
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            
            let overlayFrame = imagePicker.view.bounds
            UIGraphicsBeginImageContext(overlayFrame.size)
            UIRectFillUsingBlendMode(CGRect(x: 0, y: imagePicker.navigationBar.bounds.size.height, width: overlayFrame.size.width, height: 300), .normal);
            
            let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let overlay = UIImageView(frame: overlayFrame)
            overlay.image = overlayImage
            overlay.alpha = 1.0
            imagePicker.cameraOverlayView = overlay
            
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
   
    
    
}

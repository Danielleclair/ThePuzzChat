//
//  HomeScreenScrollVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/9/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenVC: UIPageViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    
    private struct Constants {
        static let tabBarHeight: CGFloat = 50.0
        static let storyboardName = "HomeScreen"
    }
    
    let tabBar = UIStackView()
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
        
        var selectedIconName: String {
            switch self {
            case .PuzzView: return "PuzzIconSelected"
            case .FriendsView: return "FriendsIconSelected"
            case .StoreView: return "StoreTabSelected"
            case .AccountView: return "AccountIconSelected"
            case .CreatePuzzView: return "CreateNewPuzzSelected"
            }
        }
        
        var iconName: String {
            switch self {
            case .PuzzView: return "PuzzIcon"
            case .FriendsView: return "FriendsIcon"
            case .StoreView: return "StoreTab"
            case .AccountView: return "AccountIcon"
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
        
        static func viewTypeForController(viewController: UIViewController) -> Views? {
            if viewController as? PuzzVC != nil {
                return .PuzzView
            }
            if viewController as? FriendsListVC != nil {
                return .FriendsView
            }
            if viewController as? ShopVC != nil {
                return .StoreView
            }
            if viewController as? AccountVC != nil {
                return .AccountView
            }
            return nil
        }
    }
    
    var selectedIndex = 0
    var tabButtons: [UIButton] = []
    var views: [UIViewController] = []
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        let accountBarHeight = viewHeight / 20
        let accountBar = UIView(frame: CGRect(x: 0, y: 20, width: viewWidth, height: accountBarHeight))
        
        tabBar.backgroundColor = UIColor.darkGray
        tabBar.distribution = .fillEqually
        
        self.view.addSubview(tabBar)
        self.view.addSubview(accountBar)
        
        let puzzPoint = UIImageView(image: UIImage(named: "PuzzPoint"))
        puzzPoint.frame = CGRect(x: viewWidth / 25, y: 0, width: accountBarHeight, height: accountBarHeight)
        accountBar.addSubview(puzzPoint)
        
        let puzzPointLabel = UILabel(frame: CGRect(x: (viewWidth / 25) + accountBarHeight, y: 0, width: viewWidth / 4, height: accountBarHeight))
        puzzPointLabel.text = "1000"
        puzzPointLabel.textColor = UIColor.white
        accountBar.addSubview(puzzPointLabel)
        
        createHomeScreenViews()
        configureTabBar()
    }
    
    // MARK: Page view controller methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentView = views.index(of: viewController) else { return nil }
        let indexBeforeCurrentView = indexOfCurrentView - 1
        guard indexBeforeCurrentView >= 0 else { return nil }
        return views[indexBeforeCurrentView]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let indexOfCurrentView = views.index(of: viewController) else { return nil }
        let indexAfterCurrentView = indexOfCurrentView + 1
        guard indexAfterCurrentView < views.count else { return nil }
        return views[indexAfterCurrentView]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let vc = pageViewController.viewControllers?.last {
            setSelected(viewController: vc)
        }
    }
    
    // MARK: Helper methods
    
    private func createHomeScreenViews() {
        
        views += [UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Views.PuzzView.storyboardID)]
        views += [UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Views.FriendsView.storyboardID)]
        views += [UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Views.StoreView.storyboardID)]
        views += [UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Views.AccountView.storyboardID)]
        
        guard let initialView = views.first else { return }
        
        setViewControllers(([initialView]), direction: .forward, animated: false, completion: nil)
    }
    
    private func navigate(toView view: Views) {
        guard views.count > view.rawValue else { return }
        setViewControllers([views[view.rawValue]], direction: .forward, animated: false, completion: nil)
        setSelected(viewController: views[view.rawValue])
    }
    
    private func createHomeViewNavigationButton(view: Views) {
        let navigationButton = UIButton()
        navigationButton.setImage(UIImage(named: view.iconName), for: .normal)
        navigationButton.addTarget(self, action: view.navigationAction, for: .touchUpInside)
        tabBar.addArrangedSubview(navigationButton)
        tabButtons += [navigationButton]
    }
    
    private func setSelected(viewController: UIViewController) {
        for  i in 0..<views.count {
            let view = views[i]
            
            if let viewType = Views.viewTypeForController(viewController: view) {
                
                if view == viewController {
                    tabButtons[i].setImage(UIImage(named: viewType.selectedIconName), for: .normal)
                } else {
                    tabButtons[i].setImage(UIImage(named: viewType.iconName), for: .normal)
                }
            }
        }

    }
    
    private func configureNavigationButtons() {
    
        createHomeViewNavigationButton(view: .PuzzView)
        createHomeViewNavigationButton(view: .FriendsView)
        
        let createPuzzButton = UIButton()
        createPuzzButton.setImage(UIImage(named: Views.CreatePuzzView.iconName), for: .normal)
        tabBar.addArrangedSubview(createPuzzButton)
    
       // createHomeViewNavigationButton(view: .CreatePuzzView)
        createHomeViewNavigationButton(view: .StoreView)
        createHomeViewNavigationButton(view: .AccountView)

    }
    
    private func configureTabBar() {
        let heightConstraint = tabBar.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight)
        let leadingAnchor = tabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingAnchor = tabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomAnchor = tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([heightConstraint, leadingAnchor, trailingAnchor, bottomAnchor])
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

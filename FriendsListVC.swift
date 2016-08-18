//
//  FriendsListVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/10/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit


class FriendsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var friendsList: UITableView!
    
    var user: User?
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: "FriendsListUpdated", object: nil)
        
        friendsList.delegate = self
        friendsList.dataSource = self
        
        user = User.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        print(user?.friendsList.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendCellVC
        
        if (user != nil)
        {
            cell.friend = user!.friendsList[indexPath.row]
            cell.Username.text = user!.userName!
            
            if (cell.friend!.requestAccepted)
            {
                cell.AcceptButton.hidden = true
                cell.DeclineButton.hidden = true
            }
            else
            {
                cell.AcceptButton.hidden = false
                cell.DeclineButton.hidden = false
            }
        }
        

        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(User.sharedInstance.friendsList.count)
        return User.sharedInstance.friendsList.count
    }
    
    func reloadData()
    {
        friendsList.reloadData()
    }
    
     
}

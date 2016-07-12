//
//  FriendsListVC.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/10/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit


class FriendsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var friendsList: UITableView!
    
    override func viewDidLoad() {
        
        friendsList.delegate = self
        friendsList.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! FriendCellVC
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    
}

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "FriendsListUpdated"), object: nil)
        
        friendsList.delegate = self
        friendsList.dataSource = self
        
        user = User.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(user?.friendsList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendCellVC
        
        if (user != nil)
        {
            cell.friend = user!.friendsList[indexPath.row]
            cell.Username.text = user!.userName!
            
            if (cell.friend!.requestAccepted)
            {
                cell.AcceptButton.isHidden = true
                cell.DeclineButton.isHidden = true
            }
            else
            {
                cell.AcceptButton.isHidden = false
                cell.DeclineButton.isHidden = false
            }
        }
        

        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(User.sharedInstance.friendsList.count)
        return User.sharedInstance.friendsList.count
    }
    
    func reloadData()
    {
        friendsList.reloadData()
    }
    
     
}

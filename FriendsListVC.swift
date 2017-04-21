//
//  FriendsListVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/10/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

protocol ShowAlert {
    func showAlert(title: String?, message: String?)
}

class FriendsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowAlert
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
        cell.delegate = self
        
        guard let user = user else { return cell }

            cell.friend = user.friendsList[indexPath.row]
            cell.Username.text = cell.friend?.userName
        
        switch user.friendsList[indexPath.row].requestAccepted {
        case .accepted:
            cell.RequestPendingLabel.isHidden = true
            cell.AcceptButton.isHidden = true
            cell.DeclineButton.isHidden = true
        case .awaitingResponse:
            cell.RequestPendingLabel.isHidden = false
            cell.AcceptButton.isHidden = true
            cell.DeclineButton.isHidden = true
        case .pending:
            cell.RequestPendingLabel.isHidden = true
            cell.AcceptButton.isHidden = false
            cell.DeclineButton.isHidden = false
        case .declined: break
            //TODO: Implement
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
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
     
}

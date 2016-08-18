//
//  PuzzVC.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/10/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import UIKit

class PuzzVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var messageFeed: UITableView!
    
    override func viewDidLoad() {
        messageFeed.delegate = self
        messageFeed.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! MessageCellVC
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}
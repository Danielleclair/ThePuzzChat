//
//  FirebaseManager.swift
//  ThePuzzChat
//
//  Created by Daniel Leclair on 7/12/16.
//  Copyright © 2016 Daniel Leclair. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FirebaseManager: NSObject
{
    static let sharedInstance = FirebaseManager()

    private let user: User
    
    let databaseReference: FIRDatabaseReference //Reference to the root of the database
    var authenticationReference: FIRAuth? //Reference to the authorization object
    let storageReference : FIRStorage //Reference to the blob storage
    let usersReference: FIRDatabaseReference //Reference to the user data
    let friendsListReference: FIRDatabaseReference //Reference to friendslist data
    let inboxReference: FIRDatabaseReference //Reference to the inbox data
    
    private override init()
    {
        FIRApp.configure()
        
        //Set the references to Firebase
        databaseReference = FIRDatabase.database().reference()
        authenticationReference = FIRAuth.auth()
        storageReference = FIRStorage.storage()
        usersReference = databaseReference.child("users")
        friendsListReference = databaseReference.child("friends")
        inboxReference = databaseReference.child("inbox")
        
        //Get reference to user singleton
        user = User.sharedInstance
    }

    //MARK -- Account authorization and creation
    
    //---------------------------------------------------------------------------------------------
    //Get the current authorization state of account. If authorized, caches the values in the user
    //singleton object. Current auth state should always be checked when the app is launched.
    //Callback indicates whether the user is logged in, and if a username has been chosen
    //respectively.
    //---------------------------------------------------------------------------------------------
    func GetUserAuthState(callback: (Bool, Bool)->())
    {
        authenticationReference?.addAuthStateDidChangeListener({ (auth, account) in
        
            if let account = account //User is signed in
            {
                self.user.email = account.email
                self.user.userID = account.uid
                
                self.getUserData(account.uid, callback: {(success) in
                
                    if (success)
                    {
                        callback(true, true) //User is signed in, and a username has been chosen
                    }
                    else
                    {
                        callback(true, false) //User is signed in, but no username has been chosen
                    }
                
                })
                
                //Observe for changes to inbox and friends list
                //self.getInboxMessage(account.uid)
                //self.getFriendsList(account.uid)
                
                //Test
                self.getInboxMessage("123456789")
                self.getFriendsList("123456789")
            }
            else
            {
                callback(false, false) //Not signed in
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Create a new user account
    //---------------------------------------------------------------------------------------------
    func CreateNewUser(email: String, password: String, callback: (Bool, String?)->())
    {
        authenticationReference?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            //Check for errors
            if (error != nil)
            {
                if (error!.code == FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse.rawValue)
                {
                    callback(false, "Error - Email already in use")
                }
                else if (error!.code == FIRAuthErrorCode.ErrorCodeWeakPassword.rawValue)
                {
                    callback(false, "Error - Weak password")
                }
                else
                {
                    callback(false, "An error occured")
                }
            }
            else
            {
                //Get the unique ID and create user
                if (user != nil)
                {
                    let newUser = User.sharedInstance
                    newUser.userID = user!.uid
                    newUser.email = email
                
                    callback(true, nil)
                }
                else
                {
                    callback(false, "Error fetching user account")
                }

            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Authorize user email and password.
    //---------------------------------------------------------------------------------------------
    func SignIn(email: String, password: String, callback: (Bool, String?)->())
    {
        authenticationReference?.signInWithEmail(email, password: password, completion: { (user, error) in
    
            if (error == nil)
            {
                if (user != nil)
                {
                    let newUser = User.sharedInstance
                    newUser.email = email
                    newUser.userID = user!.uid
                    
                    //self.getUserData(user!.uid)
                    self.getInboxMessage(user!.uid)
            
                    callback(true, nil)
                }
            }
            else
            {
                if (error!.code == FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue)
                {
                    callback(false, "Error - Email not recognized")
                }
                else if (error!.code == FIRAuthErrorCode.ErrorCodeWrongPassword.rawValue)
                {
                    callback(false, "Error - Incorrect password entered")
                }
                else
                {
                    callback(false, "Error - Sign in error")
                }
            }
        })
    }
    
    //MARK -- Database requests
    
    func AddNewUser(username: String, callback: (Bool)->())
    {
        let user = User.sharedInstance
        user.userName = username
        
        if (user.userID != nil)
        {
            usersReference.child(User.sharedInstance.userID!).setValue(["username" : username])
            databaseReference.child("inbox").child(User.sharedInstance.userID!)
            databaseReference.child("friends").child(User.sharedInstance.userID!)
            
            //Register for updates
            databaseReference.child("inbox").child("123456789").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                
                print(snapshot.value)
    
            })
            
            callback(true)
        }
        else
        {
            callback(false)
        }
    }
    
    func SendPuzzchat(toUserID: String)
    {
        let user = User.sharedInstance
        
        if (user.userID != nil && user.userName != nil)
        {
            databaseReference.child("inbox").child(toUserID).childByAutoId().setValue(["fromUserID" : user.userID!, "fromUserName" : user.userName!, "puzzleSize" : 3, "imageLink" : "www.thisisalink.com", "message" : "Great job with the puzzle!", "sendDate" : NSDate().timeIntervalSince1970])
        }

    }
    
    //---------------------------------------------------------------------------------------------
    //Get user specific data from ID. On completion, callback is called to indicate whether user
    //was found successfully
    //---------------------------------------------------------------------------------------------
    private func getUserData(userID: String, callback: (Bool)->())
    {
        self.usersReference.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject] //User account exists
            {
                User.sharedInstance.userName = data["username"] as? String
                callback(true)
            }
            else //User account does not exist
            {
                callback(false)
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Get messages from user inbox
    //---------------------------------------------------------------------------------------------
    private func getInboxMessage(userID: String)
    {
        self.user.inbox.removeAll() //Update inbox
        
        self.databaseReference.child("inbox").child(userID).observeEventType(.ChildAdded, withBlock: { (snapshot) in

            if let data = snapshot.value as? [String : AnyObject]
            {
                let message = data["message"] as! String
                let puzzleSize = data["puzzleSize"] as! Int
                let sendDate = data["sendDate"] as! Double
                let fromUserName = data["fromUserName"] as! String
                let fromUserID = data["fromUserID"] as! String
                //let imageLink = data["imageLink"] as! String
                
                self.user.inbox += [Message(_fromUserID: fromUserID, _fromUserName: fromUserName, _message: message, _sendDate: NSDate(timeIntervalSince1970: sendDate), _puzzleSize: puzzleSize)]
                
                //Post notification of updated inbox
                NSNotificationCenter.defaultCenter().postNotificationName("MessageReceived", object: nil)
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Get friends list
    //---------------------------------------------------------------------------------------------
    private func getFriendsList(userID: String)
    {
        user.inbox.removeAll() //Update inbox
        
        self.databaseReference.child("friends").child(userID).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let data = snapshot.value as? [String : AnyObject]
            {
                let friendID = data["friendID"] as! String
                let friendName = data["friendName"] as! String
                
                self.user.friendsList += [Friend(_userID: friendID, _userName: friendName)]
                
                //Post notification of updated friendslist
                NSNotificationCenter.defaultCenter().postNotificationName("FriendsListUpdated", object: nil)
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Add friend to friends list
    //---------------------------------------------------------------------------------------------
    func AddFriendToFriendsList(email: String)
    {
        print(email)
        
        usersReference.queryEqualToValue(email, childKey: "email")
        
            
            /*
            .observeSingleEventOfType(.Value, withBlock: {(snapshot) -> Void in
            
            print(snapshot.value)
            
            if let data = snapshot.value as? [String: AnyObject]
            {
                print("running")
            }
        })
 */
    }
    
    
    
    //---------------------------------------------------------------------------------------------
    //Add new friend
    //---------------------------------------------------------------------------------------------
    func AddFriendWithEmail(email: String)
    {
        //authenticationReference.user
    }
}
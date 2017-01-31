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

    fileprivate let user: User
    
    let databaseReference: FIRDatabaseReference //Reference to the root of the database
    var authenticationReference: FIRAuth? //Reference to the authorization object
    let storageReference : FIRStorage //Reference to the blob storage
    let usersReference: FIRDatabaseReference //Reference to the user data
    let friendsListReference: FIRDatabaseReference //Reference to friendslist data
    let inboxReference: FIRDatabaseReference //Reference to the inbox data
    
    fileprivate override init()
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
    func GetUserAuthState(_ callback: @escaping (Bool, Bool)->())
    {
        authenticationReference?.addStateDidChangeListener({ (auth, account) in
        
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
                self.getInboxMessage(account.uid)
                self.getFriendsList(account.uid)
                
                //Test
                //self.getInboxMessage("123456789")
                //self.getFriendsList("123456789")
            }
            else
            {
                callback(false, false) //Not signed in
                
                //If user signed out, pop the navigation stack
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Create a new user account
    //---------------------------------------------------------------------------------------------
    func CreateNewUser(_ email: String, password: String, callback: @escaping (Bool, String?)->())
    {
        authenticationReference?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            //Check for errors
            if let error = error?._code, let errorCode = FIRAuthErrorCode(rawValue: error)
            {
                switch errorCode {
                case .errorCodeEmailAlreadyInUse: callback(false, "Error - Email already in use")
                case .errorCodeWeakPassword: callback(false, "Error - Email already in use")
                default: callback(false, "Error fetching user account")
                }
            }
            else {
                //Get the unique ID and create user
                if let user = user {
                    let newUser = User.sharedInstance
                    newUser.userID = user.uid
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
    func SignIn(_ email: String, password: String, callback: @escaping (Bool, String?)->())
    {
        authenticationReference?.signIn(withEmail: email, password: password, completion: { (user, error) in
    
            if let error = error?._code, let errorCode = FIRAuthErrorCode(rawValue: error) {
                
                switch errorCode {
                case .errorCodeInvalidEmail: callback(false, "Error - Email not recognized")
                case .errorCodeWrongPassword: callback(false, "Error - Incorrect password entered")
                default: callback(false, "Error - Sign in error")
                }
            } else  {
                if let user = user
                {
                    let newUser = User.sharedInstance
                    newUser.email = email
                    newUser.userID = user.uid
                    
                    self.getInboxMessage(user.uid)
            
                    callback(true, nil)
                }
            }
        })
    }
    
    //MARK -- Database requests
    
    func AddNewUser(_ username: String, callback: (Bool)->())
    {
        let user = User.sharedInstance
        user.userName = username
        
        if (user.userID != nil)
        {
            usersReference.child(User.sharedInstance.userID!).setValue(["username" : username, "uid" : user.userID!])
            databaseReference.child("inbox").child(User.sharedInstance.userID!)
            databaseReference.child("friends").child(User.sharedInstance.userID!)
            
            //Register for updates
            databaseReference.child("inbox").child("123456789").observe(.childAdded, with: { (snapshot) in
                
                print(snapshot.value)
    
            })
            
            callback(true)
        }
        else
        {
            callback(false)
        }
    }
    
    func SendPuzzchat(_ toUserID: String)
    {
        let user = User.sharedInstance
        
        if (user.userID != nil && user.userName != nil)
        {
            databaseReference.child("inbox").child(toUserID).childByAutoId().setValue(["fromUserID" : user.userID!, "fromUserName" : user.userName!, "puzzleSize" : 3, "imageLink" : "www.thisisalink.com", "message" : "Great job with the puzzle!", "sendDate" : Date().timeIntervalSince1970])
        }

    }
    
    //---------------------------------------------------------------------------------------------
    //Get user specific data from ID. On completion, callback is called to indicate whether user
    //was found successfully
    //---------------------------------------------------------------------------------------------
    fileprivate func getUserData(_ userID: String, callback: @escaping (Bool)->())
    {
        self.usersReference.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    fileprivate func getInboxMessage(_ userID: String)
    {
        self.user.inbox.removeAll() //Update inbox
        
        self.databaseReference.child("inbox").child(userID).observe(.childAdded, with: { (snapshot) in

            if let data = snapshot.value as? [String : AnyObject]
            {
                let message = data["message"] as! String
                let puzzleSize = data["puzzleSize"] as! Int
                let sendDate = data["sendDate"] as! Double
                let fromUserName = data["fromUserName"] as! String
                let fromUserID = data["fromUserID"] as! String
                //let imageLink = data["imageLink"] as! String
                
                self.user.inbox += [Message(_fromUserID: fromUserID, _fromUserName: fromUserName, _message: message, _sendDate: Date(timeIntervalSince1970: sendDate), _puzzleSize: puzzleSize)]
                
                //Post notification of updated inbox
                NotificationCenter.default.post(name: Notification.Name(rawValue: "MessageReceived"), object: nil)
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Get friends list
    //---------------------------------------------------------------------------------------------
    fileprivate func getFriendsList(_ userID: String)
    {
        self.databaseReference.child("friends").child(userID).observe(.value, with: { (snapshot) in
            
            if ( snapshot.value is NSNull )
            {
                
                print("Does not exist")
                
            }
            else
            {
                self.user.friendsList.removeAll() //Update inbox
                
                if var data = snapshot.value as? [String : AnyObject]
                {
                    data = (data.values.first as? [String : AnyObject])!
                    
                    let friendID = data["friendID"] as! String
                    let friendName = data["friendName"] as! String
                    let requestAcceptedInt = data["requestAccepted"] as! Int
                    
                    let requestAccepted: Bool
                    if (requestAcceptedInt == 0)
                    {
                        requestAccepted = false
                    }
                    else
                    {
                        requestAccepted = true
                    }
                    
                    self.user.friendsList += [Friend(_userID: friendID, _userName: friendName, _requestAccepted: requestAccepted)]
                    
                    //Post notification of updated friendslist
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "FriendsListUpdated"), object: nil)
                }

            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Add friend to friends list
    //---------------------------------------------------------------------------------------------
    func SendFriendRequestToUser(_ username: String, callback: @escaping (String)->())
    {
        usersReference.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            if ( snapshot.value is NSNull )
            {
                
                callback("User does not exist")
                
            }
            else
            {
                if let data = snapshot.value as? [String : AnyObject]
                {
                        //Check to make sure user isn't adding themself
                        if (data["uid"] as? String != self.user.userID!)
                        {
                            print("Okay, adding user to friends")
                            self.databaseReference.child("friends").child(data["uid"] as! String).child(self.user.userID!).setValue(["friendID" : self.user.userID!, "requestAccepted" : 0, "friendName" : self.user.userName!])
                        }
                        else
                        {
                            callback("Error - Cannot add self as friend")
                        }
                }
            }
            
            }, withCancel: { (error) in
                
                //Return the error is the callback
                callback("An error occurred")
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Accept friend request
    //---------------------------------------------------------------------------------------------
    func AcceptFriendRequest(_ userID: String)
    {
        databaseReference.child("friends").child(user.userID!).child(userID).updateChildValues(["requestAccepted": 1])
    }
    
    //---------------------------------------------------------------------------------------------
    //Decline friend request
    //---------------------------------------------------------------------------------------------
    func DeclineFriendRequest(_ userID: String)
    {
        databaseReference.child("friends").child(user.userID!).child(userID).removeValue()
    }
    
    //---------------------------------------------------------------------------------------------
    //Add new friend
    //---------------------------------------------------------------------------------------------
    func AddFriendWithEmail(_ email: String)
    {
        //authenticationReference.user
    }
    
    //---------------------------------------------------------------------------------------------
    //Sign out of user's account
    //---------------------------------------------------------------------------------------------
    func SignOut()
    {
        do {
            try authenticationReference?.signOut()
        } catch {
        }
        
    }
}

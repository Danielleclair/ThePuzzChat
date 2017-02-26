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

typealias AuthenticationResponse = (isAuthorized: Bool, hasCreatedPuzzatar: Bool)

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
    let emailReference: FIRDatabaseReference //Reference to user email / UID associations
    
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
        emailReference = databaseReference.child("email")
        
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
    func GetUserAuthState(_ callback: @escaping (AuthenticationResponse)->())
    {
        var firstAuthCall = true
        authenticationReference?.addStateDidChangeListener({ [weak self] (auth, account) in
        
            // Listener called twice when first added; ignore first callback
            //guard firstAuthCall == false else { firstAuthCall = false; return}
            
            if let account = account //User is signed in
            {
                self?.user.email = account.email
                self?.user.userID = account.uid
                
                if let displayName = account.displayName {
                    self?.user.userName = displayName
                    callback((true, true))
                    return
                }
                
                callback((true, false))
                
                debugPrint(account.displayName)
                
                //Observe for changes to inbox and friends list
                self?.addAllObservers(uid: account.uid)
                
                //Test
                //self.getInboxMessage("123456789")
                //self.getFriendsList("123456789")
            }
            else
            {
                callback((false, false)) //Not signed in
                
                //If user signed out, pop the navigation stack
            }
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Create a new user account
    //---------------------------------------------------------------------------------------------
    func CreateNewUser(_ email: String, password: String, callback: @escaping (Bool, String?)->())
    {
        authenticationReference?.createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
            
            //Check for errors
            if let error = error?._code, let errorCode = FIRAuthErrorCode(rawValue: error)
            {
                switch errorCode {
                case .errorCodeEmailAlreadyInUse: callback(false, "Error - Email already in use")
                case .errorCodeWeakPassword: callback(false, "Error - Password does not meet requirements")
                default: callback(false, "Error fetching user account")
                }
            } else {
                //Get the unique ID and create user
                if let user = user {
                    let newUser = User.sharedInstance
                    newUser.userID = user.uid
                    newUser.email = email
                    
                    let emailKey = email.replacingOccurrences(of: ".", with: "_") // Firebase cannot handle periods in keys
        
                    self?.inboxReference.child("inbox").child(user.uid)
                    self?.friendsListReference.child("friends").child(user.uid)
                    self?.emailReference.child(emailKey).setValue(["userID": user.uid])
                    
                    callback(true, nil)
                } else {
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
        authenticationReference?.signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
    
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
                    
                    self?.addAllObservers(uid: user.uid)
            
                    callback(true, nil)
                }
            }
        })
    }
    
    // MARK: Database requests
    
    func AddNewUser(_ username: String, callback: (Bool)->())
    {
        let user = User.sharedInstance
        user.userName = username
        
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = username
        
        changeRequest?.commitChanges(completion: nil)
        
        if let userID = user.userID
        {
            usersReference.child(userID).setValue(["username" : username, "uid" : userID])
            
            //Register for updates
            databaseReference.child("inbox").child(userID).observe(.childAdded, with: { (snapshot) in
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
    private func getUserData(_ userID: String, callback: @escaping (Bool)->())
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
    private func observeInboxMessage()
    {
        guard let userID = User.sharedInstance.userID else { return }
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
    //Add all observers
    //---------------------------------------------------------------------------------------------
    private func addAllObservers(uid: String) {
        observeInboxMessage()
        observeFriendsList()
    }
    
    
    //---------------------------------------------------------------------------------------------
    //Get friends list
    //---------------------------------------------------------------------------------------------
    private func observeFriendsList()
    {
        guard let userID = User.sharedInstance.userID else { return }
        self.databaseReference.child("friends").child(userID).observe(.value, with: { [weak self] (snapshot) in
            
            self?.user.friendsList.removeAll() //Update friendslist
            
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            
            for _ in data {
                guard let friendID = data["friendID"] as? String, let friendName = data["friendName"] as? String, let requestAccepted = data["requestAccepted"] as? Int else { continue }
                
                self?.user.friendsList += [Friend(_userID: friendID, _userName: friendName, _requestAccepted: requestAccepted)]
            }
            
                    //Post notification of updated friendslist
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "FriendsListUpdated"), object: nil)
        })
    }
    
    //---------------------------------------------------------------------------------------------
    //Add friend to friends list.
    //---------------------------------------------------------------------------------------------
    func SendFriendRequest(with email: String)
    {
        guard User.sharedInstance.email != email else { return } // Can't add yourself as a friend
        let email = email.replacingOccurrences(of: ".", with: "_") // Firebase cannot handle periods in keys
        emailReference.child(email).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let data = snapshot.value as? [String: AnyObject], let friendID = data["userID"] as? String else { return }
            let user = User.sharedInstance
            guard let uid = user.userID, let username = user.userName else  { return }
            self?.friendsListReference.child(friendID).child(uid).setValue(["friendName" : username, "requestAccepted" : 0])
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
    //Sign out of user's account
    //---------------------------------------------------------------------------------------------
    func SignOut() -> Bool
    {
        do {
            try authenticationReference?.signOut()
            return true
        } catch {
            return false
        }
    }
}

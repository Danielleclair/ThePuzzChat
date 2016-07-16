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

    let databaseReference: FIRDatabaseReference
    var authenticationReference: FIRAuth?
    let storageReference : FIRStorage
    
    let usersReference: FIRDatabaseReference
    
    private override init()
    {
        FIRApp.configure()
        
        databaseReference = FIRDatabase.database().reference()
        authenticationReference = FIRAuth.auth()
        storageReference = FIRStorage.storage()
        
        usersReference = databaseReference.child("users")
        
        
    }
    
    //Creates a new user account. If the account already exists, signs the user in instead
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
    
    func SignIn(email: String, password: String, callback: (Bool, String)->())
    {
        authenticationReference?.signInWithEmail(email, password: password, completion: { (user, error) in
    
            if (error != nil)
            {
                if (user != nil)
                {
                    let newUser = User.sharedInstance
                    newUser.email = email
                    newUser.userID = user!.uid
                    
                    self.usersReference.child(user!.uid).observeEventType(.ChildAdded, withBlock: { (snapshot) in
                        
                        print(snapshot.value)
                        
                    })
                    
                    self.databaseReference.child("inbox").child("123456789").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                        
                        print(snapshot.value)
                        
                    })
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
    
    
    
}
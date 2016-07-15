//
//  FirebaseManager.swift
//  ThePuzzChat
//
//  Created by Danielle Rosaia on 7/12/16.
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
    func CreateNewUser(email: String, password: String, callback: (String)->())
    {
        authenticationReference?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            //Check for errors
            if (error != nil)
            {
                if (error!.code == FIRAuthErrorCode.ErrorCodeEmailAlreadyInUse.rawValue)
                {
                    callback("Error - Email already in use")
                }
                else if (error!.code == FIRAuthErrorCode.ErrorCodeInvalidEmail.rawValue)
                {
                    callback("Error - Invalid email address")
                }
                else
                {
                    callback("An error occured")
                }
            }
            else
            {
                //Get the unique ID and create
                if (user != nil)
                {
                    user?.uid
                }
                else
                {
                    callback("Error fetching user account")
                }

            }
        })
    }
    
}
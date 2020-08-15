//
//  DataManager.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 14/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DataManager {
    
    static let shared = DataManager()
    
    // let db = Firestore.firestore()
    let usersReference = Firestore.firestore().collection("users")
    let locationsReference = Firestore.firestore().collection("locations")
    let notesReference = Firestore.firestore().collection("notes")

    
    // MARK: User Session
    
    // Save user information into the database.
    // Return error message to print it on the error label if failed, else return nil.
    func saveUserData(username: String, uid: String, email: String) {
        
        let newUser = User(uid: uid, username: username, email: email)
        
        usersReference.addDocument(data: newUser.dictionary) { (error) in
            if error != nil {
                print("Error saving user data into the database: \(error!)")
            }
        }
    }
    
    
    // MARK: Note Session
    
    // Save note into the database.
    // Return true if saved successfully, false if failed.
    func saveNoteData(content: String, date: Timestamp, location: GeoPoint, userID: String) -> Note? {
        
        var ref: DocumentReference? = nil
        
        let newNote = Note(content: content, date: date, userID: userID, location: location)
        
        ref = notesReference.addDocument(data: newNote.dictionary) { error in
            if error != nil {
                print("Error saving user data into the database: \(error!)")
            }
        }
        
        if ref != nil {
            return newNote
        } else {
            return nil
        }
    }
    
    
    // MARK: Location Session
    
    // Save location into the database.
    func saveLocationData(latitude: Double, longitude: Double) {
        
        let location = GeoPoint(latitude: latitude, longitude: longitude)
        
        let newLocation = Location(location: location)
        
            locationsReference.addDocument(data: newLocation.dictionary) { (error) in
            if error != nil {
                print("Error saving user data into the database: \(error!)")
            }
        }
    }
    
}

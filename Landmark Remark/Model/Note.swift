//
//  Note.swift
//  
//
//  Created by Zhiyu He on 14/8/20.
//

import Foundation
import FirebaseFirestore

struct Note {
    
    var content: String
    var date: Timestamp
    var userID: String
    var location: GeoPoint
    
    var dictionary: [String: Any] {
        return [
            "content": content,
            "date": date,
            "userID": userID,
            "location": location
        ]
    }
}


// Initialized note instance easily.
extension Note: DocumentationSerializable {
    init?(dictionary: [String : Any]) {
        guard let content = dictionary["content"] as? String,
            let date = dictionary["date"] as? Timestamp,
            let userID = dictionary["userID"] as? String,
            let location = dictionary["location"] as? GeoPoint else {
                return nil
        }
        
        self.init(content: content, date: date, userID: userID, location: location)
    }
}

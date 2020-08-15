//
//  User.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 14/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import Foundation
import FirebaseAuth


struct User {
    
    var uid: String
    var username: String
    var email: String
    
    // Encoding user information as a dictionary.
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "username": username,
            "email": email
        ]
    }
}


// By this function, user will be easy to be initialized.
extension User: DocumentationSerializable {
    init?(dictionary: [String : Any]) {
        guard let uid = dictionary["uid"] as? String,
            let username = dictionary["username"] as? String,
            let email = dictionary["email"] as? String else {
                return nil
        }
        
        self.init(uid: uid, username: username, email: email)
    }
}

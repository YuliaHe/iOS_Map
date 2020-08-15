//
//  Location.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 14/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Location {
    
    // GeoPoint.init(latitude: Double, longitude: Double)
    var location: GeoPoint
    
    // Encoding user information as a dictionary.
    var dictionary: [String: Any] {
        return [
            "location": location,
        ]
    }
    
}


// By this function, location will be easy to be initialized.
extension Location: DocumentationSerializable {
    init?(dictionary: [String : Any]) {
        guard let location = dictionary["location"] as? GeoPoint else {
            return nil
        }
        
        self.init(location: location)
    }
}

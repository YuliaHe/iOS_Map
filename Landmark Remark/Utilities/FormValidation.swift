//
//  FormValidation.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 12/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import Foundation
import UIKit

class FormValidation {
    
    // Check if password contains one big letter, one number and and is minimum eight char long.
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")
        
        return passwordCheck.evaluate(with: password)
    }
}

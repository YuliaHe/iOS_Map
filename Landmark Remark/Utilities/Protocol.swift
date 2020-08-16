//
//  Protocol.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 14/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import Foundation

// Used to initialize struct.
protocol DocumentationSerializable {
    init?(dictionary: [String:Any])
}

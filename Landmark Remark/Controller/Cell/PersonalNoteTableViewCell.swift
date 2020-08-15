//
//  PersonalNoteTableViewCell.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 15/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit

class PersonalNoteTableViewCell: UITableViewCell {
    
    var currentNote: Note!
    
    @IBOutlet weak var noteContentTextView: UITextView!
    
    @IBOutlet weak var dateOfNoteLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!

}

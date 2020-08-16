//
//  NoteTableViewCell.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 15/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var currentNote: Note!

    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var dateOfNoteLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
}

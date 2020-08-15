//
//  CommunityViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 13/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allNotesTableView: UITableView!
    
    var notesArray = [Note]()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        checkForUpdatesInNote()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        let currentNote = notesArray[indexPath.row]
        
        cell.currentNote = currentNote
        
        cell.noteContentTextView.text = currentNote.content
        cell.dateOfNoteLabel.text = dateFormatter.string(from: currentNote.date.dateValue())
        // TODO: 下面两个要把id string改成对应的名称.
        cell.usernameButton.setTitle(currentNote.userID, for: .normal)
        
        let location = currentNote.location
        cell.locationLabel.text = "[\(location.latitude)° N, \(location.longitude)° E]"
        
        return cell
    }

    func loadData() {

        DataManager.shared.notesReference.getDocuments() { querySnapshot, error in
            if let err = error {
                print("\(err.localizedDescription)")
            } else {
                for doc in querySnapshot!.documents {
                    let note = Note(dictionary: doc.data())
                    self.notesArray.append(note!)

                    DispatchQueue.main.async {
                        self.allNotesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    // Update after view loaded.
    func checkForUpdatesInNote() {
        
        DataManager.shared.notesReference.whereField("date", isGreaterThan: Date())
            .addSnapshotListener { (querySnapshot, error) in
            
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        self.notesArray.append(Note(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.allNotesTableView.reloadData()
                        }
                    }
                }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

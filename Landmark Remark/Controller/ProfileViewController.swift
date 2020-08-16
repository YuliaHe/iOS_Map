//
//  ProfileViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 13/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: User!
    var personalNotes = [Note]()
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()

    @IBOutlet weak var personalNotesTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var amountOfNotesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        fetchNotesOfCurrentUser()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(nil, forKey: "userKeepLoginStatus")
        } catch {
            print ("error signing out", error)
        }
        
        // get your storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewController(withIdentifier: "InitialVC") as! InitialViewController

        // Because self.window is an optional you should check it's value first and assign your rootViewController
        view.window?.rootViewController = rootController
        view.window?.makeKeyAndVisible()

        navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personalNoteCell", for: indexPath) as! PersonalNoteTableViewCell
        
        let currentNote = personalNotes[indexPath.row]
        
        cell.currentNote = currentNote
        
        cell.noteContentTextView.text = currentNote.content
        cell.dateOfNoteLabel.text = dateFormatter.string(from: currentNote.date.dateValue())
        
        let location = currentNote.location
        let geoLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        CLGeocoder().reverseGeocodeLocation(geoLocation) { (placemarks, err) in
            if err != nil {
                print("reverse geocoding failed: \(err)")
            } else {
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    cell.locationLabel.text = pm.name ?? pm.thoroughfare
                }
            }
        }
        
        return cell
    }
    
    func setupUI() {
        userNameLabel.text = currentUser.username
        userEmailLabel.text = currentUser.email
        amountOfNotesLabel.text = "\(currentUser.username) has \(personalNotes.count) notes"
    }
    
    // Get user document id and all noted by this user.
    private func fetchNotesOfCurrentUser() {
        let userDoc = DataManager.shared.usersReference.whereField("uid", isEqualTo: currentUser.uid)

        userDoc.getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting user documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                  
                    DataManager.shared.usersReference.document(doc.documentID).collection("personalNotes").getDocuments { (noteQuerySnapshot, error) in
                        if let error = error {
                            print("Error getting note documents: \(error)")
                        } else {
                            
                            for noteDoc in noteQuerySnapshot!.documents {
                                let noteDocID = Array(noteDoc.data().values)[0] as! String
                                let noteRef = DataManager.shared.notesReference.document(noteDocID)
                                
                                noteRef.getDocument { (noteDocument, error) in
                                    if let document = noteDocument, document.exists {
                                        
                                        let note = Note(dictionary: document.data()!)
                                        self.personalNotes.append(note!)
                                        
                                        self.personalNotes.sort(by:{$0.date.dateValue() > $1.date.dateValue()})
                                        
                                        DispatchQueue.main.async {
                                            self.personalNotesTableView.reloadData()
                                        }
                                        
                                        self.amountOfNotesLabel.text = "\(self.currentUser.username) has \(self.personalNotes.count) notes."
                                        
                                    } else {
                                        print("Note does not exist")
                                    }
                                }
                            }
                        }
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

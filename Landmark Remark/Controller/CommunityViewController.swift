//
//  CommunityViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 13/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allNotesTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var notesArray = [Note]()
    var filteredNotesArray = [Note]()
    
    // True if the text typed in the search bar is empty; otherwise, returns false.
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Refers to the isActive property of searchController to determine which array to display.
    var isFiltering: Bool {
        let searchBarIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarIsFiltering)
    }
    
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
        
        setupSearchController()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // tableview delegate. Return the amount of cell. Here is the amount of the notes.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredNotesArray.count
        }
        
        return notesArray.count
    }
    
    // setup the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        let currentNote: Note
        
        if isFiltering {
            currentNote = filteredNotesArray[indexPath.row]
        } else {
            currentNote = notesArray[indexPath.row]
        }
        
        cell.currentNote = currentNote
        
        cell.noteContentTextView.text = currentNote.content
        cell.dateOfNoteLabel.text = dateFormatter.string(from: currentNote.date.dateValue())
        cell.usernameButton.setTitle(currentNote.username, for: .normal)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNote: Note
        
        if isFiltering {
            currentNote = filteredNotesArray[indexPath.row]
        } else {
            currentNote = notesArray[indexPath.row]
        }
        
        let userDoc = DataManager.shared.usersReference.whereField("uid", isEqualTo: currentNote.userID)

        userDoc.getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting user documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    let user = User(dictionary: doc.data())
                    self.performSegue(withIdentifier: "goToOtherUserPage", sender: user)
                }
            }
        }
    }
    
    // Filter notes based on searchText to match content of note and put the results in filteredNotes.
    func filterContentForSearchText(_ searchText: String, content: String? = nil) {
        filteredNotesArray = notesArray.filter { (note: Note) -> Bool in
            return note.content.lowercased().contains(searchText.lowercased())
        }
        
        allNotesTableView.reloadData()
    }
    
    // Filter notes based on searchText to match username of note and put the results in filteredNotes.
    func filterUsernameForSearchText(_ searchText: String, username: String? = nil) {
        filteredNotesArray = notesArray.filter { (note: Note) -> Bool in
            return note.username.lowercased().contains(searchText.lowercased())
        }
        
        allNotesTableView.reloadData()
    }

    // Load all notes data and sort by date to display them.
    func loadData() {

        DataManager.shared.notesReference.getDocuments() { querySnapshot, error in
            if let err = error {
                print("\(err.localizedDescription)")
            } else {
                for doc in querySnapshot!.documents {
                    let note = Note(dictionary: doc.data())
                    self.notesArray.append(note!)
                    
                    self.notesArray.sort(by:{$0.date.dateValue() > $1.date.dateValue()})

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
                        self.notesArray.sort(by:{$0.date.dateValue() > $1.date.dateValue()})
                        
                        DispatchQueue.main.async {
                            self.allNotesTableView.reloadData()
                        }
                    }
                }
        }
    }
    
    // Setup the Search Controller
    func setupSearchController() {
        // Procotol
        searchController.searchResultsUpdater = self
        
        // Current view is set to show the results, so not obscure the view.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        
        // Add search bar to the navigation item.
        navigationItem.searchController = searchController
        
        // Ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller.
        definesPresentationContext = true
        
        // Set title for each scope.
        searchController.searchBar.scopeButtonTitles = ["note", "username"]
        searchController.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the profile view controller using segue.destination.
        // Pass the selected user to the profile
        if segue.identifier == "goToOtherUserPage" {
            if let destinationVC = segue.destination as? ProfileViewController {
                destinationVC.currentUser = sender as? User
            }
        }
        
    }

}


// UISearchResultsUpdating Delegate
// In order for community view controller to respond to the search bar.
extension CommunityViewController: UISearchResultsUpdating {
    
    // Update search results based on information the user enters into the search bar,
    // which in turn calls filterContentForSearchText(_:category:).
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if scope == "note" {
            filterContentForSearchText(searchBar.text!)
        } else if scope == "username" {
            filterUsernameForSearchText(searchBar.text!)
        }
    }
    
}

// UISearchBar Delegate
// Implement the scope bar
extension CommunityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchBar.scopeButtonTitles![selectedScope]
        if scope == "note" {
            filterContentForSearchText(searchBar.text!)
        } else if scope == "username" {
            filterUsernameForSearchText(searchBar.text!)
        }
        
    }
    
    
}


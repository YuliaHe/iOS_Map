//
//  HomeViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 12/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentUser: User!
    var currentUserReference: DocumentReference!
    
    var currentLocation = GeoPoint(latitude: 33.8568, longitude: 151.2153)
    
    var allPersonalNotes = [Note]() // All notes created by current user.
    var allLocations = [Location]()
    
    var myLocationManager: CLLocationManager!
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        let userInfoDictionary = UserDefaults.standard.dictionary(forKey: "userKeepLoginStatus")
        currentUser = User(dictionary: userInfoDictionary!)
        
        // Know document id first.
        fetchNotesOfCurrentUser()
    }
    
    @IBAction func createANoteTapped(_ sender: UIButton) {
        
        let typingAlert = UIAlertController(title: "New Note", message: "Enter your note at \(currentLocation.latitude)° N, \(currentLocation.longitude)° E", preferredStyle: .alert)
        
        typingAlert.addTextField { (noteTextField) in
            noteTextField.placeholder = "Your note"
        }
        
        typingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        typingAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let content = typingAlert.textFields![0].text
//            let username = self.currentUser.username // 要修改下面
            let date = Date()
            let location = self.currentLocation
            
            DataManager.shared.saveNoteData(content: content ?? "Just marked it.", date: Timestamp(date: date), location: location, userID: self.currentUser.uid, username: self.currentUser.username)
            
            // Add a annotation on the mao.
            let locationAnnotation = MKPointAnnotation()
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
            locationAnnotation.coordinate = locationCoordinate
            
            locationAnnotation.title = self.dateFormatter.string(from: date)
            locationAnnotation.subtitle = content
            
            self.myMapView.addAnnotation(locationAnnotation)
        }))
        
        self.present(typingAlert, animated: true, completion: nil)
    }
    
    @IBAction func goToProfileTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfileVC", sender: currentUser)
    }
    
    // Set up map view and its manager.
    func setupLocationManager() {
        myMapView.userTrackingMode = .followWithHeading
        
        myLocationManager = CLLocationManager()
        // Update location when moving one meter.
        myLocationManager.distanceFilter = 1
        // Set accuracy (better accuracy is more battery consuming)
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        getUserAuthor()
    }
    
    // Put annotations on the map for marking.
    func addAnnotationsOnMapView() {
        // Mark all location and the content of note.
        for note in allPersonalNotes {
            allLocations.append(Location(location: note.location))
            
            let locationAnnotation = MKPointAnnotation()
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: note.location.latitude, longitude: note.location.longitude)
            locationAnnotation.coordinate = locationCoordinate
            
            locationAnnotation.title = dateFormatter.string(from: note.date.dateValue())
            locationAnnotation.subtitle = note.content
            
            self.myMapView.addAnnotation(locationAnnotation)
        }
    }
    
    // Get user document id and all noted by him.
    fileprivate func fetchNotesOfCurrentUser() {
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
                                        self.allPersonalNotes.append(note!)
                                        self.addAnnotationsOnMapView()
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
    
    
    fileprivate func getUserAuthor() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Get authorization from user first time launching app.
            myLocationManager.requestWhenInUseAuthorization()
            fallthrough
        case .authorizedWhenInUse:
            myLocationManager.startUpdatingLocation() // Start location
        case .denied:
            let alertController = UIAlertController(title: "Error", message:"GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }

    }
    
    // Get current location coordinates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let localValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let currentLatitude = localValue.latitude
        let currentLongitude = localValue.longitude
        
        currentLocation = GeoPoint(latitude: currentLatitude, longitude: currentLongitude)
        
        print("locations = \(localValue.latitude) \(localValue.longitude)")
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the profile view controller using segue.destination.
        // Pass the current user to the profile
        if segue.identifier == "goToProfileVC" {
            if let navVC = segue.destination as? UINavigationController {
                
                if let destinationVC = navVC.viewControllers[0] as? ProfileViewController {
                    destinationVC.currentUser = sender as? User
                    
                }
            }
        }
    }
    

}

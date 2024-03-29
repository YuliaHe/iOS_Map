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

class HomeViewController: UIViewController {
    
    var currentUser: User!
    var currentUserReference: DocumentReference!
    
    var currentLocation = GeoPoint(latitude: -28.45, longitude: 153.03)
    
    var allNotes = [Note]() // All notes created by all users.
    
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
        
        loadAllNotesData()
        checkForUpdatesInNote()
    }
    
    @IBAction func createANoteTapped(_ sender: UIButton) {
        
        let geoLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        CLGeocoder().reverseGeocodeLocation(geoLocation) { (placemarks, err) in
            if err != nil {
                print("reverse geocoding failed: \(err)")
            } else {
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    
                    let locationStr = pm.name ?? pm.thoroughfare
                    let typingAlert = UIAlertController(title: "New Note", message: "Enter your note at \(locationStr!)", preferredStyle: .alert)
                    
                    typingAlert.addTextField { (noteTextField) in
                        noteTextField.placeholder = "Your note"
                    }
                    
                    typingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    typingAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                        let content = typingAlert.textFields![0].text
                        let date = Date()
                        let location = self.currentLocation
                        
                        DataManager.shared.saveNoteData(content: content ?? "Just marked it.", date: Timestamp(date: date), location: location, userID: self.currentUser.uid, username: self.currentUser.username)
                        
                        // Add a annotation on the mao.
                        let locationAnnotation = MKPointAnnotation()
                        
                        let locationCoordinate = CLLocationCoordinate2D(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
                        locationAnnotation.coordinate = locationCoordinate
                        
                        locationAnnotation.title = "\(self.currentUser.username), \(self.dateFormatter.string(from: date))"
                        locationAnnotation.subtitle = content
                        
                        self.myMapView.addAnnotation(locationAnnotation)
                    }))
                    
                    self.present(typingAlert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func goToProfileTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfileVC", sender: currentUser)
    }
    
    // Set up map view and its manager.
    func setupLocationManager() {
        
        myMapView.userTrackingMode = .followWithHeading
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        // Update location when moving one meter.
        myLocationManager.distanceFilter = 1
        // Set accuracy (better accuracy is more battery consuming)
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        getUserAuthor()
    }
    
    func loadAllNotesData() {

        DataManager.shared.notesReference.getDocuments() { querySnapshot, error in
            if let err = error {
                print("\(err.localizedDescription)")
            } else {
                for doc in querySnapshot!.documents {
                    let note = Note(dictionary: doc.data())
                    self.allNotes.append(note!)

                    DispatchQueue.main.async {
                        self.addAnnotationsOnMapView()
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
                        let note = Note(dictionary: diff.document.data())
                        self.allNotes.append(note!)

                        DispatchQueue.main.async {
                            self.addAnnotationsOnMapView()
                        }
                    }
                }
        }
    }
    
    // Put annotations on the map for marking.
    func addAnnotationsOnMapView() {
        // Mark all location and the content of note.
        for note in allNotes {
            
            let locationAnnotation = MKPointAnnotation()
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: note.location.latitude, longitude: note.location.longitude)
            locationAnnotation.coordinate = locationCoordinate
            
            locationAnnotation.title = "\(note.username), \(dateFormatter.string(from: note.date.dateValue()))"
            locationAnnotation.subtitle = note.content
            
            self.myMapView.addAnnotation(locationAnnotation)
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


extension HomeViewController: CLLocationManagerDelegate {
    
    // Get current location coordinates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localValue: CLLocation = locations[0] as CLLocation
        
        let currentLatitude = localValue.coordinate.latitude
        let currentLongitude = localValue.coordinate.longitude
        
        currentLocation = GeoPoint(latitude: currentLatitude, longitude: currentLongitude)
    }
}



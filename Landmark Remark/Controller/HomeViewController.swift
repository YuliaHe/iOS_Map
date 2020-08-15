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
    var currentLocation = GeoPoint(latitude: 11.11, longitude: 12.23)
    
    var myLocationManager: CLLocationManager!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupMapView()
        
        let userInfoDictionary = UserDefaults.standard.dictionary(forKey: "userKeepLoginStatus")
        currentUser = User(dictionary: userInfoDictionary!)
        
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
            
            DataManager.shared.saveNoteData(content: content ?? "Just marked it.", date: Timestamp(date: date), location: location, userID: self.currentUser.username)
            
            // 刷新map 在地图上新建一个大头针
        }))
        
        self.present(typingAlert, animated: true, completion: nil)
    }
    
    @IBAction func goToProfileTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfileVC", sender: currentUser)
    }
    
    func setupLocationManager() {
        myLocationManager = CLLocationManager()
        
        // Update location when moving 100m
        myLocationManager.distanceFilter = 100
        // Set accuracy (better is more battery consuming)
        myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        getUserAuthor()
    }
    
    func setupMapView() {
        myMapView.userTrackingMode = .followWithHeading
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
            let alertController = UIAlertController(title: "定位權限已關閉", message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
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

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

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var myLocationManager: CLLocationManager!
    var currentLatitude: CLLocationDegrees!
    var currentLongitude: CLLocationDegrees!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocationManager()
        setupMapView()
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
        
        currentLatitude = localValue.latitude
        currentLongitude = localValue.longitude
        
        print("locations = \(localValue.latitude) \(localValue.longitude)")
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

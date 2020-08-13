//
//  AppDelegate.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 12/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        setRootViewController()
        
        return true
    }
    
    // Keep user logged in.
    func setRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser != nil {
            
            // Go to the homepage.
            let homeViewController = storyboard.instantiateViewController(identifier: "HomeVC") as? HomeViewController
            
            // Make it as key window.
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
            
        } else {
            
            // Go to the initial page.
            let initialViewController = storyboard.instantiateViewController(identifier: "InitialVC") as? InitialViewController
            
            // Make it as key window.
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
    }

}


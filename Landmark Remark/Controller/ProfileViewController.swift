//
//  ProfileViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 13/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

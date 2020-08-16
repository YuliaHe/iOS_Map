//
//  LoginViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 12/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Collect the data from textfield.
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // sign in in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                let userQuery = DataManager.shared.usersReference.whereField("email", isEqualTo: email)
                userQuery.getDocuments { (userSnapshot, err) in
                    if let err = err {
                        print("Error getting user: \(err)")
                    } else {
                        for userDoc in userSnapshot!.documents {
                            // Store info dictionary of current user logged in.
                            UserDefaults.standard.set(userDoc.data(), forKey: "userKeepLoginStatus")
                            self.goToHomePage()
                        }
                    }
                }
            }
        }
    }
    
    func setupUI() {
        
        // Hide the error label.
        errorLabel.alpha = 0
        
        // Style all textfields.
        UICustomStyle.styleTextField(emailTextField)
        UICustomStyle.styleTextField(passwordTextField)
    }
    
    // Go to the home page.
    func goToHomePage() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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

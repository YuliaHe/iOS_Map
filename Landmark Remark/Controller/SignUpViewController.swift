//
//  SignUpViewController.swift
//  Landmark Remark
//
//  Created by Zhiyu He on 12/8/20.
//  Copyright © 2020 Zhiyu.H. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        // Validate the field.
        let error = validateFields()
        
        if error != nil {
            
            // Show error message on error label.
            showError(error!)
        } else {
            // Collect the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user.
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if let err = err {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, noew store the username into the database.
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username": username, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    // Transition to the home screen.
                    self.goToHomePage()
                }
            
            
            }
            
        }
        
    }
    
    func setupUI() {
        
        // Hide the error label.
        errorLabel.alpha = 0
        
        // Style all textfields.
        UICustomStyle.styleTextField(usernameTextField)
        UICustomStyle.styleTextField(emailTextField)
        UICustomStyle.styleTextField(passwordTextField)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text == "" || passwordTextField.text == "" {
            return "Please fill in all field."
        }
        
        // Check if the password is secure
        let passwordStr = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if FormValidation.isPasswordValid(passwordStr) == false {
            return "At least 8 char long with 1 capital letter and 1 number."
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goToHomePage() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
        
        // Make it as key window.
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

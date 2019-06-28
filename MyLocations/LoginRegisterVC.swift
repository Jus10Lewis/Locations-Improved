//
//  LoginRegisterVC.swift
//  MyLocations
//
//  Created by Justin Lewis on 6/17/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginRegisterVC: UIViewController {
    
    let IS_DEBUG_MODE = true
    
    var isNewRegistration = false
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewRegistration{
            title = "Register New User"
            loginRegisterButton.setTitle("REGISTER", for: .normal)
        } else{
            title = "Login"
            loginRegisterButton.setTitle("LOGIN", for: .normal)
        }
        
    }
    
    @IBAction func enterInfo(_ sender: Any) {
        if IS_DEBUG_MODE {
            SVProgressHUD.show()
            loginUser ("me4@me.com", "qwertyu")
            return
        }
        
        guard let email = emailTextField.text else {
            return
        }
        guard let pwd = passwordTextField.text else {
            return
        }
        
        if email == "" || pwd == "" {
           showEmptyTextFieldAlert()
        } else {
            SVProgressHUD.show()
        }
        
        
        if isNewRegistration {
            registerNewUser(email, pwd)
        } else {
            loginUser (email, pwd)
        }
    }
    
    
    fileprivate func registerNewUser(_ email: String, _ pwd: String) {
        Auth.auth().createUser(withEmail: email, password: pwd) {
            (result, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
                self.performSegue(withIdentifier: "GoToChat", sender: nil)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func loginUser(_ email: String, _ pwd: String) {
        Auth.auth().signIn(withEmail: email, password: pwd) { (result, error) in
            if error != nil {
                print(error!)
            } else {
                print("Login Successful!")
                self.performSegue(withIdentifier: "GoToChat", sender: nil)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func showEmptyTextFieldAlert() {
        let alert = UIAlertController(title: "Empty Field", message: "Fill out a valid email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//
//  SelectLoginTypeVC.swift
//  MyLocations
//
//  Created by Justin Lewis on 6/18/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit

class SelectLoginTypeVC: UIViewController {
    
    var isNewRegistration = false
    
    @IBOutlet var avatarImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "avatarID") != nil {
            let avatarID = UserDefaults.standard.integer(forKey: "avatarID")
            avatarImageView.downloaded(from: "https://api.adorable.io/avatars/285/\(avatarID).png")
        } else {
            chooseNewAvatar(nil)
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        isNewRegistration = true
        performSegue(withIdentifier: "GoToLogin", sender: nil)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        isNewRegistration = false
        performSegue(withIdentifier: "GoToLogin", sender: nil)
    }
    
    @IBAction func chooseNewAvatar(_ sender: Any?) {
        let avatarID = Int.random(in: 1...10000)
        avatarImageView.downloaded(from: "https://api.adorable.io/avatars/285/\(avatarID).png")
        UserDefaults.standard.set(avatarID, forKey: "avatarID")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! LoginRegisterVC
        nextVC.isNewRegistration = self.isNewRegistration
    }
}




//
//  VenUTabBarViewController.swift
//  VenU App
//
//  Created by X Code User on 12/7/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class VenUTabBarViewController: UITabBarController {

    var userId : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().isTranslucent = false
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.userId = user.uid
                for child in self.childViewControllers {
                    if let nc = child as? UINavigationController {
                        if let c = nc.childViewControllers[0]
                            as? VenUTopLevelViewController {
                            c.userId = self.userId
                        }
                    }
                }
            } else {
                // No user is signed in.
                self.performSegue(withIdentifier: "presentLogin", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func unwindFromSignup(segue: UIStoryboardSegue) {
        // we end up here when the user signs up for a new account.
        print("unwind to TabBarController")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

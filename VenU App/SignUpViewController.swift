//
//  SignUpViewController.swift
//  VenU App
//
//  Created by X Code User on 12/4/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    var USER : User?
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    var validationErrors = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.passwordConfirm.delegate = self
        
        // dismiss keyboard when tapping outside of text fields
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func validateFields() -> Bool {
        
        let pwOk = self.isEmptyOrNil(str: self.passwordField.text)
        if !pwOk {
            self.validationErrors += "Password cannot be blank. "
        }
        
        let pwMatch = self.passwordField.text == self.passwordConfirm.text
        if !pwMatch {
            self.validationErrors += "Passwords do not match. "
        }
        
        let emailOk = self.isValidEmail(emailStr: self.emailField.text)
        if !emailOk {
            self.validationErrors += "Invalid email address."
        }
        
        return emailOk && pwOk && pwMatch
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if self.validateFields() {
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                if let  _ = user {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = tabBarController
                    appDelegate.window?.makeKeyAndVisible()
                    //self.dismiss(animated: true, completion: nil)
                } else {
                    self.passwordField.text = ""
                    self.passwordConfirm.text = ""
                    self.passwordField.becomeFirstResponder()
                    self.reportError(msg: (error?.localizedDescription)!)
                }
            }
        } else {
            self.reportError(msg: self.validationErrors)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.passwordConfirm.becomeFirstResponder()
        } else {
            if self.validateFields() {
                print("Congratulations!  You entered correct values.")
            }
        }
        return true
    }
}

extension UIViewController {
    
    func isEmptyOrNil(str : String?) -> Bool {
        guard let s = str, !s.isEmpty else {
            return false
        }
        return true
    }
    
    func isValidEmail(emailStr : String? ) -> Bool
    {
        var emailOk = false
        if let email = emailStr {
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
            emailOk = emailPredicate.evaluate(with: email)
        }
        return emailOk
    }
    
    func reportError(msg: String) {
        let alert = UIAlertController(title: "Failed", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

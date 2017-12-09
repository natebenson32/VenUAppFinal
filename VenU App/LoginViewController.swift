//
//  LoginViewController.swift
//  VenU App
//
//  Created by X Code User on 11/28/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications

class LoginViewController: UIViewController {
    
    var validationErrors = ""

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        if self.validateFields() {
            print("Congratulations!  You entered correct values.")
            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                if let _ = user {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = tabBarController
                    appDelegate.window?.makeKeyAndVisible()
                } else {
                    self.reportError(msg: (error?.localizedDescription)!)
                    self.passwordField.text = ""
                    self.passwordField.becomeFirstResponder()
                }
            }
        } else {
            self.reportError(msg: self.validationErrors)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dismiss keyboard when tapping outside of text fields
        let detectTouch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        // make this controller the delegate of the text fields.
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        // for dev
        self.emailField.text = ""
        self.passwordField.text = ""
        
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
        
        let emailOk = self.isValidEmail(emailStr: self.emailField.text)
        if !emailOk {
            self.validationErrors += "Invalid email address."
        }
        
        return emailOk && pwOk
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
                                                                arguments: nil)
        
        // Configure the trigger for a 7am wakeup.
        var dateInfo = DateComponents()
        dateInfo.hour = 23
        dateInfo.minute = 58
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        // Create the request object.
        
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        
        // Play a sound.
        completionHandler(UNNotificationPresentationOptions.sound)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else {
            if self.validateFields() {
                print("Congratulations!  You entered correct values.")
            }
        }
        return true
    }

}

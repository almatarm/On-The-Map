//
//  ViewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 17/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController  {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissSupport()
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardAdjustmentSupport()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardAdjustmentSupport()
    }
    
    @IBAction func login(_ sender: Any) {
        changeLoginStatus(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            self.changeLoginStatus(false)
            if success {
                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func changeLoginStatus(_ isLoggingIn: Bool) {
        emailTextField.isEnabled = !isLoggingIn
        passwordTextField.isEnabled = !isLoggingIn
        loginButton.isEnabled = !isLoggingIn
        activityIndicator.isHidden = !isLoggingIn
        
        if isLoggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }

    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:])
    }
}

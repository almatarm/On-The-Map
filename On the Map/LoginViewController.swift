//
//  ViewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 17/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLink: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        styleViews()
    }
    
    func styleViews() {
        loginButton.layer.cornerRadius = 5
       
        let linkedText = NSMutableAttributedString(attributedString: signUpLink.attributedText!)
        let hyperlinked = linkedText.setAsLink(textToFind: "Sign Up", linkURL: "https://auth.udacity.com/sign-in")
        
        if hyperlinked {
            signUpLink.attributedText = NSAttributedString(attributedString: linkedText)
        }
    }

    

}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}


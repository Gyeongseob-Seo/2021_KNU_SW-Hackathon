//
//  SingUpViewController.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/23.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var radius: Int = 22
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        signUpButton.layer.cornerRadius = CGFloat(radius)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        
        guard let username = usernameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) {
            authResult, error in
            if let e = error {
                print(e)
            } else {
                if let mainViewController = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController {
//                    mainViewController.modalPresentationStyle = .fullScreen
//                    present(mainViewController, animated: true, completion: nil)
                    self.navigationController?.pushViewController(mainViewController, animated: true)
                }
            }
        }
    }
    
    
}

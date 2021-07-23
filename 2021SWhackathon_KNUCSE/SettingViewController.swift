//
//  SettingViewController.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/23.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = loginVC

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveToLogin(_ sender: Any) {
        let firebaseAuth = Auth.auth()
              do {
                  try firebaseAuth.signOut()
                  self.navigationController?.popToRootViewController(animated: true)
                print("로그아웃 성공")

              } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
              }
    }
}

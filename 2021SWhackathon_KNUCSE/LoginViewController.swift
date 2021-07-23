//
//  ViewController.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var userModel = UserModel() // 인스턴스 생성

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var radius: Int = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTextField.layer.cornerRadius = CGFloat(radius)
        passwordTextField.layer.cornerRadius = CGFloat(radius)
        signInButton.layer.cornerRadius = CGFloat(radius)
        signUpButton.layer.cornerRadius = CGFloat(radius)
        
        //키보드 내리기
        usernameTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        signInButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    } // end of viewDidLoad
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = usernameTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
            
        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: usernameTextField)
            let emailLabel = UILabel(frame: CGRect(x: 68, y: 350, width: 279, height: 45))
            emailLabel.text = "이메일 형식을 확인해 주세요"
            emailLabel.textColor = UIColor.red
            emailLabel.tag = 100
                
            self.view.addSubview(emailLabel)
        } // 이메일 형식 오류
            
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            let passwordLabel = UILabel(frame: CGRect(x: 68, y: 435, width: 279, height: 45))
            passwordLabel.text = "비밀번호 형식을 확인해 주세요"
            passwordLabel.textColor = UIColor.red
            passwordLabel.tag = 101
                
            self.view.addSubview(passwordLabel)
        } // 비밀번호 형식 오류
            
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
            
            guard let username = usernameTextField.text else {
                return
            }
            guard let password = passwordTextField.text else {
                return
            }
            
            Auth.auth().signIn(withEmail: username, password: password) {
                authResult, error in
                if let e = error {
                    print("로그인 실패")
                    self.shakeTextField(textField: self.usernameTextField)
                    self.shakeTextField(textField: self.passwordTextField)
                    let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
                    loginFailLabel.text = "아이디나 비밀번호가 다릅니다."
                    loginFailLabel.textColor = UIColor.red
                    loginFailLabel.tag = 102
                        
                    self.view.addSubview(loginFailLabel)
                } else {
                    if let mainViewController = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController {
    //                    mainViewController.modalPresentationStyle = .fullScreen
    //                    present(mainViewController, animated: true, completion: nil)
                        self.navigationController?.pushViewController(mainViewController, animated: true)
                    }
                }
            }
            
            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
            if loginSuccess {
                print("로그인 성공")
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                //self.performSegue(withIdentifier: "MainViewController", sender: self)
//                if let mainViewController = self.storyboard?.instantiateViewController(identifier: "MainViewController") as? MainViewController {
////                    mainViewController.modalPresentationStyle = .fullScreen
////                    present(mainViewController, animated: true, completion: nil)
//                    self.navigationController?.pushViewController(mainViewController, animated: true)
//                }
                
                
            }
//            else {
//                print("로그인 실패")
//                shakeTextField(textField: usernameTextField)
//                shakeTextField(textField: passwordTextField)
//                let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
//                loginFailLabel.text = "아이디나 비밀번호가 다릅니다."
//                loginFailLabel.textColor = UIColor.red
//                loginFailLabel.tag = 102
//
//                self.view.addSubview(loginFailLabel)
//            }
        }
    } // end of didTapLoginButton
    
    
    final class UserModel {
        struct User {
            var email: String
            var password: String
        }
        
        var users: [User] = [
            User(email: "abc1234@naver.com", password: "qwerty1234"),
            User(email: "dazzlynnnn@gmail.com", password: "asdfasdf5678"),
            User(email: "syhbong9@knu.ac.kr", password: "maro0315")
        ]
        
        // 아이디 형식 검사
        func isValidEmail(id: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: id)
        }
        
        // 비밀번호 형식 검사
        func isValidPassword(pwd: String) -> Bool {
            let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
            return passwordTest.evaluate(with: pwd)
        }
    } // end of UserModel
    
    
    func loginCheck(id: String, pwd: String) -> Bool {
        for user in userModel.users {
            if user.email == id && user.password == pwd {
                return true // 로그인 성공
            }
        }
        return false
    }
    
    
    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
        
        
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if usernameTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    
    


}


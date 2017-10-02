//
//  LoginVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CDAlertView

class LoginVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    let loginRequest = M_UserRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTxt.delegate = self
        passwordTxt.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginBtnAct(_ sender: UIButton) {
        
//        guard  let email = emailTxt.text , email.isEmail else {
//            print("invalid email")
//            self.view.showSimpleAlert("Warning", "Invalid Email address", .warning)
//            return
//        }
//        guard let password = passwordTxt.text , password.isValidPassword else {
//            self.view.showSimpleAlert("Warning", "Password has to contain more than 8 characters", .warning)
//            return
//        }
        let email = "2@1.com"
        let password = "qqqqqqqq"
          sender.alpha = 0.5
        self.view.isUserInteractionEnabled = false
        loginRequest.postLoginRequest(email: email, password: password) { [weak self] (data, state, sms ) in
            
            guard   state  else {
                DispatchQueue.main.async {
                    self?.view.showSimpleAlert("Error", sms, .error)
                      sender.alpha = 1
                    self?.view.isUserInteractionEnabled = true
                }
                return
              }
            guard let data = data  else {
                DispatchQueue.main.async {
                    sender.alpha = 1
                    self?.view.isUserInteractionEnabled = true
                }
                return }
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = false
            }
            let alert = CDAlertView(title: "Welcome Back", message: "Welcome Back", type: .success)
            alert.hideAnimations = { (center, transform, alpha) in
                self?.view.isUserInteractionEnabled = false
                transform = CGAffineTransform(scaleX: 3, y: 3)
                alpha = 0
                DispatchQueue.main.async {
 
                         ad.saveUserLogginData(email: data.email, photoUrl: nil, uid: data.id, name: data.name)
                        ad.reloadWithAnimation()
                        
                 }
            }
            alert.hideAnimationDuration = 0.45
            alert.show()
 
    }
        }
        
    
    @IBAction func creatAccountBtnAct(_ sender: UIButton) {
        
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func forgotPasswordBtnAct(_ sender: UIButton) {
        let vc = ForgotPasswordVC()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  LoginVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
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
        
        guard  let email = emailTxt.text , email.isEmail else {
            print("invalid email")
            return
        }
        
        guard let password = passwordTxt.text , password.isValidPassword else {
            print("invalid password")
            return
        }
        
        
    }
    @IBAction func creatAccountBtnAct(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let initVC = storyBoard.instantiateViewController(withIdentifier: "RegisterationDetailsVC") as! RegisterationDetailsVC
        self.present(initVC, animated: true, completion: nil)
    }
    @IBAction func forgotPasswordBtnAct(_ sender: UIButton) {
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

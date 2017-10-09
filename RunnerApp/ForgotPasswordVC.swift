//
//  ForgotPasswordVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var sendBtnOL: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    
    let userRequest = M_UserRequest()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func sendBtnAct(_ sender: UIButton) {
        guard let email = emailTxt.text , email.isEmail else {
            self.view.showSimpleAlert("Error", "invalid Email Format", .error)
            return
        }
        userRequest.postForgotPassword(email: email ) { [weak self ] (state, sms ) in
            guard state else {
                self?.view.showSimpleAlert("Error", sms, .error)
                return
            }
            self?.view.showSimpleAlert("Success", "Please check your Email for the new Password", .success)
            self?.navigationController?.popViewController(animated: true )
        }
    }
    
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

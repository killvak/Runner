//
//  RegisterVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var countCodeTxt: UITextField!
    @IBOutlet weak var mobileNumTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func readTermsBtnAct(_ sender: UIButton) {
    }
    
    @IBAction func backBtnAct(_ sender: UIButton) {
    }

    
    func checkValidation() -> Bool {
        guard let fName = firstNameTxt.text , fName.isBlankOrLessThan3chr else {
            
            return false
        }
        
        guard let lName = lastNameTxt.text , lName.isBlankOrLessThan3chr else {
            
            return false
        }
        
        guard let email = emailTxt.text , email.isEmail else {
            
            return false
        }
        
        guard let password = passwordTxt.text , password.isValidPassword else {
            
            return false
        }
        
        guard let mobileCode = countCodeTxt.text else {
            
            return false
        }
        
        guard let mobilenum = mobileNumTxt.text else {
            
            return false
        }
        
        return true
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

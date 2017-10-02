//
//  RegisterVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import MICountryPicker
class RegisterVC: UIViewController , MICountryPickerDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var countryCodeSelectionBtn: UIButton!
    @IBOutlet weak var mobileNumTxt: UITextField!
    
    private let picker = MICountryPicker()
    private var acceptedTerms = false
    let requestM = M_UserRequest()
    var parameters : [String:Any] = [:]
    private var countryCOdeHasBeenSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate
        picker.delegate = self
        
        // Optionally, set this to display the country calling codes after the names
        picker.showCallingCodes = true
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)  // Allows dismissal of keyboard on tap anywhere on screen besides the keyboard itself

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true 
    }
    
    
    
    
    @IBAction func didReadTermsCheckHandler(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        acceptedTerms = sender.isSelected
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "001-checkbox"), for: .normal)
        }else {
            sender.setImage(#imageLiteral(resourceName: "002-uncheckedbox"), for: .normal)
        }
    }
    @IBAction func readTermsBtnAct(_ sender: UIButton) {
        
    }
    
    @IBAction func countryCodeSelectionHandler(_ sender: UIButton) {
        navigationController?.pushViewController(picker, animated: true)
        
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            print(dialCode)
            if !dialCode.isBlank{
                self.countryCodeSelectionBtn.setTitle("\(dialCode)", for: .normal)
                self.countryCOdeHasBeenSelected = true
                self.picker.navigationController?.popViewController(animated: true)
                
            }
            
        }
        self.view.endEditing(true   )
        
    }
    
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitHandler(_ sender: UIButton) {
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let initVC = storyBoard.instantiateViewController(withIdentifier: "RegisterationDetailsVC") as! RegisterationDetailsVC
        //
        //        self.parameters  =
        //            [
        //                "email":"bdsass2dkb@nml.com" ,
        //                "password" : "123456",
        //                "first_name" : "ahmed",
        //                "last_name" : "mohamed",
        //                "phone" : "3328399"//,
        //             //   "referal_code" : "S8i28G",
        //              //  "type" : 2
        //
        //        ]
        //                initVC.registerParameters = self.parameters
        //                self.navigationController?.pushViewController(initVC, animated: true)
        //                print("self?.navigationController?.viewControllers : \(self.navigationController?.viewControllers)")
        //                                 self.navigationController?.viewControllers.remove(at: 1)
        ////
        
        self.view.isUserInteractionEnabled = false
        guard checkValidation() else {
            self.view.isUserInteractionEnabled = true
            return
        }
        
        
        
        requestM.postRegisteredEmail(email: emailTxt.text!) { [weak self] ( status , sms) in
            
            guard status else {
                DispatchQueue.main.async {
                    self?.view.showSimpleAlert("Error", sms, .error)
                    self?.view.isUserInteractionEnabled = true
                    self?.view.showSimpleAlert("Error", sms, .error)
                }
                return
            }
            guard let parm = self?.parameters else { return }
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let initVC = storyBoard.instantiateViewController(withIdentifier: "RegisterationDetailsVC") as! RegisterationDetailsVC
                
                initVC.registerParameters = parm
                self?.navigationController?.pushViewController(initVC, animated: true)
                //                self?.removeFromParentViewController()
                
                if var viewControllers = self?.navigationController?.viewControllers {
                    for (i,viewController) in viewControllers.enumerated() {
                        // some process
                        if viewController.isKind(of: RegisterVC.self) {
                            print("yes it is \(i)")
                            self?.navigationController?.viewControllers.remove(at: i)
                        }
                    }
                }
            }
        }
    }
    
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        //        print(code)
    }
    
    private func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        //        print(dialCode)
    }
    
    private func checkValidation() -> Bool {
        guard let fName = firstNameTxt.text , !fName.isBlankOrLessThan3chr else {
            self.view.showAlert("Warning", "First name has to contain more than 3 characters ", .warning, nil)
            return false
        }
        
        guard let lName = lastNameTxt.text , !lName.isBlankOrLessThan3chr else {
            self.view.showSimpleAlert("Warning", "Last name has to contain more than 3 characters ", .warning)
            return false
        }
        
        guard let email = emailTxt.text , email.isEmail else {
            self.view.showSimpleAlert("Warning", "Invalid Email address", .warning)
            return false
        }
        
        guard let password = passwordTxt.text , password.isValidPassword else {
            self.view.showSimpleAlert("Warning", "Password has to contain more than 8 characters", .warning)
            return false
        }
        
        
        guard let mobilenum = mobileNumTxt.text , mobilenum.ispriceValue , !mobilenum.isBlankOrLessThan(8) else {
            self.view.showSimpleAlert("Warning", "PhoneNumber has to contain more than 8 characters", .warning)
            return false
        }
        
        guard countryCOdeHasBeenSelected else {
            self.view.showSimpleAlert("Warning", "Country Code is Required", .warning)
            return false
        }
        guard acceptedTerms else {
            self.view.showSimpleAlert("Warning", "have you read our Terms.", .warning)
            return false
        }
        let phoneCode = self.countryCodeSelectionBtn.title(for: .normal)
        let phoneNum = (phoneCode ?? "" ) +  mobilenum
        print("that's phoneCode + mobilenum : \(phoneNum)")
        parameters   = [
            "email" : email ,
            "password" : password,
            "first_name" : fName,
            "last_name" : lName,
            "phone" : phoneNum,
            "referal_code" : "",
            "type" : 2
            
        ]
        
        /*
         parameters : Parameters = [
         "email":"bbbd@nml.com" ,
         "password" : "123456",
         "first_name" : "ahmed",
         "last_name" : "mohamed",
         "phone" : "+90087328399",
         "referal_code" : "S8i28G",
         "type" : 2
         
         ]
         
         */
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

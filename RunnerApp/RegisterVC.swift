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

    private var countryCOdeHasBeenSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate
        picker.delegate = self
        
        // Optionally, set this to display the country calling codes after the names
        picker.showCallingCodes = true
        // Do any additional setup after loading the view.
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
        
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "001-checkbox"), for: .normal)
        }else {
            sender.setImage(#imageLiteral(resourceName: "002-uncheckedbox"), for: .normal)
        }
    }
    @IBAction func readTermsBtnAct(_ sender: UIButton) {
 	
    }
    
    @IBAction func countryCodeSelectionHandler(_ sender: UIButton) {
        self.view.endEditing(true   )
        navigationController?.pushViewController(picker, animated: true)
        picker.didSelectCountryWithCallingCodeClosure = { name, code, dialCode in
            print(dialCode)
            if !dialCode.isBlank{
                self.countryCodeSelectionBtn.setTitle("\(dialCode)", for: .normal)
                self.countryCOdeHasBeenSelected = true
                self.picker.navigationController?.popViewController(animated: true)

            }
            
        }
    }
    
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func submitHandler(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let initVC = storyBoard.instantiateViewController(withIdentifier: "RegisterationDetailsVC") as! RegisterationDetailsVC
        self.present(initVC, animated: true, completion: nil)
    }
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
//        print(code)
    }
    
    private func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
//        print(dialCode)
    }
    
    private func checkValidation() -> Bool {
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
        
        
        guard let mobilenum = mobileNumTxt.text , mobilenum.ispriceValue else {
            
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

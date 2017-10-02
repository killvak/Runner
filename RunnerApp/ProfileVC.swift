//
//  ProfileVC.swift
//  RunnerApp
//
//  Created by admin on 9/25/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CDAlertView
class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var availabilityToStartLbl: UILabel!
    
    @IBOutlet weak var timeSlotLbl: UILabel!
    @IBOutlet weak var transportationLbl: UILabel!
    let picker = UIImagePickerController()

    let profileRequest = M_UserRequest()
    var userData : User_DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        picker.delegate = self
        
        profileRequest.getProfileDataByIdRequst { [weak self ](dataValue, state, sms) in
            guard   state else {
                self?.failedRequest()
               return
            }
            guard let data = dataValue else {
                  self?.failedRequest()
                return
            }
            self?.setupData(data)
        }

    }
    
    
    func setupData(_ data : User_DataModel) {
        
        emailLbl.text = data.email
        phoneNumLbl.text = data.phone
        transportationLbl.text = data.transportation
        timeSlotLbl.text  = data.timeSlots
        
        
    }
    
    
    
    func failedRequest() {
        DispatchQueue.main.async {
            self.view.showSimpleAlert("Error!!", "Couldn't find profile,Please check your network", .error)
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.layer.cornerRadius =  profileImage.bounds.size.width   / 2
        self.profileImage.clipsToBounds = true
    }
    
    
    func imageTapped()
    {
        
         photoFromLibrary()
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
      
        
    }
    
    @IBAction func labelEditAction(_ sender: UIButton) {
        print("that's the sender tag: \(sender.tag)" )
        
        let alert = CDAlertView(title: "Edit Text", message: "", type: .notification)
        let doneAction = CDAlertViewAction(title: "sure", font: nil, textColor: nil, backgroundColor: nil) {[weak self ] (action) in
            
            guard  let x = alert.textFieldText , !x.isBlank else {
                return
            }
            
            self?.setLabelsEditText(sender.tag, x )
        
        }
        let nevermindAction = CDAlertViewAction(title: "Cancel")
        alert.isTextFieldHidden = false
        alert.textFieldPlaceholderText = "*Enter Your Text"
        
        
        alert.add(action: nevermindAction)
        alert.add(action: doneAction)

        alert.show()
    }

    func setLabelsEditText(_ tag : Int , _ text : String) {
      
        switch tag {
        case 0:
            guard text.isEmail else {
                self.view.showSimpleAlert("invalid Email", "", .warning)
                return
            }
            self.emailLbl.text = text
        case 1:
            guard text.validPhoneNumber else {
                self.view.showSimpleAlert("invalid PhoneNumber", "", .warning)
                return
            }
            self.phoneNumLbl.text = text
        case 2:
            
            self.transportationLbl.text = text
        case 3:
           
            self.availabilityToStartLbl.text = text
        case 4:
            
            self.timeSlotLbl.text = text
        default:
            break
        }
        
    }
    @IBAction func logoutHandler(_ sender: UIButton) {
        
        ad.saveUserLogginData(email: nil, photoUrl: nil, uid: nil, name: nil )
        ad.reloadWithAnimation()
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




extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    //https://makeapppie.com/2016/06/28/how-to-use-uiimagepickercontroller-for-a-camera-and-photo-library-in-swift-3-0/
    //        @IBOutlet weak var myImageView: UIImageView!
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        
    }
    
    func shootPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
         var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
                    profileImage.contentMode = .scaleAspectFill //3
                    profileImage.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


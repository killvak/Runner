//
//  ProfileVC.swift
//  RunnerApp
//
//  Created by admin on 9/25/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CDAlertView
import SwiftyStarRatingView
class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfilePopupView: UIView!
    @IBOutlet weak var editProfilePopupIconicImage: UIImageView!
    
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var availabilityToStartLbl: UILabel!
    @IBOutlet weak var cancelEditingBtnsOL: UIButton!
    
    @IBOutlet weak var editingBtnOL: UIButton!
    @IBOutlet weak var timeSlotLbl: UILabel!
    @IBOutlet weak var transportationLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var selectionDict : [String: Int] = ["morning": 1, "afternoon": 1, "late_night": 1, "evening": 1]
    fileprivate var shifts = ["Morning","Afternoon","Evening","Late Night"]
    fileprivate var shiftsparmaeters = ["morning","afternoon","evening","late_night"]
    
    fileprivate   var data = dataListItems(0)
    fileprivate var selectedTransportation = ""
    fileprivate let picker = UIImagePickerController()
    
    fileprivate  let profileRequest = M_UserRequest()
    fileprivate var userData : User_DataModel?
    fileprivate  var isEditingProfile = false
    fileprivate var selectedBtnTag = 2
    fileprivate  var backGroundBlackView : UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
                
        self.cancelEditingBtnsOL.alpha = 0 
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        picker.delegate = self
        ad.isLoading()
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
            ad.killLoading()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ratingView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.ratingView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.9) {
            self.ratingView.transform = .identity
            self.ratingView.alpha = 1
        }
    }
    
    func setupData(_ data : User_DataModel) {
        
        emailLbl.text = data.email
        phoneNumLbl.text = data.phone
        transportationLbl.text = data.transportation
        timeSlotLbl.text  = data.timeSlots
        
        
    }
    
    @IBAction func editingBtnsHandler(_ sender: UIButton) {
        
        guard  sender.tag == 0 else {
            self.cancelEditingBtnsOL.alpha = 0
            self.editingBtnOL.setBackgroundImage(UIImage(named:"edit"), for: .normal)
            editingBtnOL.isSelected = false
            return
        }
        sender.isSelected = !sender.isSelected
        guard sender.isSelected else {
            self.cancelEditingBtnsOL.alpha = 0
            self.editingBtnOL.setBackgroundImage(UIImage(named:"edit"), for: .normal)
            self.view.showSimpleAlert("Success", "", .success)
            return
        }
        self.view.showSimpleAlert("Guide", "Tap the label that needs to be updated", .notification)
        self.cancelEditingBtnsOL.alpha = 1
        self.editingBtnOL.setBackgroundImage(UIImage(named:"checked"), for: .normal)

        
    }
    
    
    func failedRequest() {
        DispatchQueue.main.async {
            self.view.showSimpleAlert("Error!!", "Couldn't find profile,Please check your network", .error)
            self.navigationController?.popViewController(animated: true)
            ad.killLoading()
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
        
    }
    
    @IBAction func labelEditAction(_ sender: UIButton) {
        print("that's the sender tag: \(sender.tag)" )
        self.view.isUserInteractionEnabled = false
        guard sender.tag != 2 else { customeViewBtnAct(sender); return }
        guard sender.tag != 4 else { customeViewBtnAct(sender); return }
        
        //
        let alert = CDAlertView(title: "Edit Text", message: "", type: .notification)
        let doneAction = CDAlertViewAction(title: "sure", font: nil, textColor: nil, backgroundColor: nil) {[weak self ] (action) in
            
            guard  let x = alert.textFieldText , !x.isBlank else {
                self?.view.isUserInteractionEnabled = true
                self?.view.showSimpleAlert("Error","Text can't be Empty", .error)
                return
            }
            
            self?.setLabelsEditText(sender.tag, x )
            
        }
        self.view.isUserInteractionEnabled = true
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
            guard text.ispriceValue ,  text.isBlankOrLessThan3chr else {
                self.view.showSimpleAlert("invalid PhoneNumber", "", .warning)
                return
            }
            self.phoneNumLbl.text = text
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



extension ProfileVC :  UITableViewDelegate,UITableViewDataSource {
    
    /*
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
     
     return data.listOfNames.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 49
     }
     
     
     
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return 4    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard selectedBtnTag == 4 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterData", for: indexPath) as! RegisterListOfDataCell
            
            cell.dataTitle.text = data.listOfNames[indexPath.row]
            //        cell.selectedBtnTag = SelectedBtnTag
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTimeSlotCell", for: indexPath) as! RegisterTimeSlotCell
        cell.name.text = shifts[indexPath.row]
        cell.yesBtnAct.tag = indexPath.row
        cell.noBtnAct.tag = indexPath.row
        cell.yesBtnAct.addTarget(self, action: #selector(yesBtnSelected(_:)), for: .touchUpInside)
        cell.noBtnAct.addTarget(self, action: #selector(noBtnSelected(_:)), for: .touchUpInside)
        return cell    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {        return nil     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedBtnTag != 4 else {
            
            return
        }
        //        let cell = tableView.cellForRow(at: indexPath) as! RegisterListOfDataCell
        
        print("that's it : \(data.listOfNames[indexPath.row])" )
        selectedTransportation = data.listOfNames[indexPath.row]
    }
    
    func handleCellBtnSelection(_ tag : Int ,_ state : Bool) {
        let indexP = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexP) as! RegisterTimeSlotCell
        
        
        if state {
            cell.yesBtn.setBackgroundImage(#imageLiteral(resourceName: "radioBtn-on"), for: .normal)
            cell.noBtn.setBackgroundImage(#imageLiteral(resourceName: "radioBtn-off"), for: .normal)
            
        }else {
            cell.noBtn.setBackgroundImage(#imageLiteral(resourceName: "radioBtn-on"), for: .normal)
            cell.yesBtn.setBackgroundImage(#imageLiteral(resourceName: "radioBtn-off"), for: .normal)
            
        }
    }
    
    func yesBtnSelected(_ sender : UIButton) {
        
        selectionDict[shiftsparmaeters[sender.tag]] = Int(true)
        handleCellBtnSelection(sender.tag, true)
        
        print("that's the selection List : \(selectionDict)")
    }
    
    func noBtnSelected(_ sender : UIButton) {
        
        selectionDict[shiftsparmaeters[sender.tag]] = Int(false)
        handleCellBtnSelection(sender.tag, false)
        print("that's the selection List : \(selectionDict)")
    }
}

//Custome Popup View
extension ProfileVC  {
    
    
    func customeViewBtnAct(_ sender : UIButton) {
        setupEditProfilePopupView()
        self.backGroundBlackView.isUserInteractionEnabled = false
        selectedBtnTag = sender.tag
        
        self.editProfilePopupIconicImage.image = sender.tag == 2 ? UIImage(named:"001-sports") : UIImage(named:"time")
        self.tableView.reloadData()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.editProfilePopupView.alpha = 1
            self.editProfilePopupView.transform = .identity
            
        }, completion: { (true) in
            
            self.view.isUserInteractionEnabled = true
            self.backGroundBlackView.isUserInteractionEnabled = true
            
        })
    }
    
    func setupEditProfilePopupView() {
        
        backGroundBlackView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.screenSize.height))
        backGroundBlackView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissEditPopupView))
        backGroundBlackView.addGestureRecognizer(tapGesture)
        self.navigationController?.view.addSubview(backGroundBlackView)
        
        //        let customVC = ChangePassViewX.instanceFromNib()
        //        ratingView.frame = CGRect(x: 0, y: 60, width: Constants.screenSize.width - 50 , height:  Constants.screenSize.width - 50 )
        //        forgotPassView =
        
        editProfilePopupView.frame = CGRect(x: 0, y: 60, width: 290 , height: 258 )
        editProfilePopupView.layer.borderWidth = 1
        editProfilePopupView.layer.cornerRadius = 10
        editProfilePopupView.layer.masksToBounds = true
        editProfilePopupView.layer.borderColor = UIColor.white.cgColor
        editProfilePopupView.clipsToBounds = true
        editProfilePopupView.center = view.center
        editProfilePopupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        self.navigationController?.view.addSubview(editProfilePopupView)
        
    }
    
    func dismissEditPopupView() {
        self.view.isUserInteractionEnabled = false
        self.backGroundBlackView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.backGroundBlackView.alpha = 0
            self.editProfilePopupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.editProfilePopupView.alpha = 0
        }) { [weak self ] (true ) in
            self?.editProfilePopupView.transform = CGAffineTransform.identity
            self?.editProfilePopupView.removeFromSuperview()
            self?.backGroundBlackView.removeFromSuperview()
            self?.view.isUserInteractionEnabled = true
        }
        
    }
    @IBAction func HandleSelectionEditViewPopup(_ sender: UIButton) {
        dismissEditPopupView()
        guard selectedBtnTag == 4 else {
            print("selected : '\(selectedTransportation)")
            transportationLbl.text = selectedTransportation
            return
        }
        var finalString = ""
        for (key ,value) in selectionDict {
            //            print(" key \(key) value in \(value)")
            guard value == 1 else { continue }
            finalString.append("| \(key.capitalized) | ")
        }
        
        timeSlotLbl.text = finalString.isBlank ? "None": finalString
    }
    
    @IBAction func cancelPopupSelection(_ sender: UIButton) {
        dismissEditPopupView()
    }
    
    
}


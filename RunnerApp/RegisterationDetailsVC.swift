//
//  RegisterationDetailsVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CDAlertView

protocol doneWithRegisterProtocol : class  {
    func doneWithRegister()
}
class RegisterationDetailsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var profilePickingBtn: UIButton!
    @IBOutlet weak var licensePickingBtn: UIButton!
    @IBOutlet weak var VehicleInsurancePickingBtn: UIButton!
 
    weak var delegate : doneWithRegisterProtocol?
    var registerParameters : [String:Any] = [:]

    var the3FieldsDict : [String:String] = [:]
    let activityInd : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView()
        ai.color = .green
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    var selectionDict : [String: Int] = [:]
    var imagesDict : [String : UIImage] = [:]
    let picker = UIImagePickerController()
    
    var currentBtntag : Int?
    var shifts = ["Morning","Afternoon","Evening","Late Night"]
    var shiftsparmaeters = ["morning","afternoon","evening","late_night"]
    let registerRequest = M_UserRequest()

     override func viewDidLoad() {
        super.viewDidLoad()
        
        //yourButton.contentHorizontalAlignment = .left
        
        // Do any additional setup after loading the view.
        for i in 0...shifts.count - 1 {
            selectionDict[shiftsparmaeters[i]] = Int(true)
            print(i)
        }
        picker.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard self.isBeingDismissed else { return }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     UIView.transition(from: self.datesView, to: daysView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTimeSlotCell", for: indexPath) as! RegisterTimeSlotCell
        cell.name.text = shifts[indexPath.row]
        cell.yesBtnAct.tag = indexPath.row
        cell.noBtnAct.tag = indexPath.row
        cell.yesBtnAct.addTarget(self, action: #selector(yesBtnSelected(_:)), for: .touchUpInside)
        cell.noBtnAct.addTarget(self, action: #selector(noBtnSelected(_:)), for: .touchUpInside)
        return cell    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil 
    }
    
    @IBAction func imageSelectionTrigger(sender : UIButton) {

//        shootPhoto()
        let actionSheet :UIAlertController = UIAlertController(title: "Image Selection",  message: "Select your image from : " , preferredStyle: .actionSheet
            
        )
        let cancle:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photos :UIAlertAction = UIAlertAction(title: "Photos Gallery", style: .default) { UIAlertAction in
         self.photoFromLibrary()
        }
        let camera :UIAlertAction = UIAlertAction(title: "User Camera", style: .default) { UIAlertAction in
              self.shootPhoto()
        }
        actionSheet.addAction(photos)

        actionSheet.addAction(camera)

        actionSheet.addAction(cancle)
        self.present(actionSheet, animated: true, completion: nil)

        currentBtntag = sender.tag
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

    @IBAction func registerBtnHandler(_ sender: UIButton) {

//        m.multiPart1(imageDict: imagesDict) { (data) in
//
//
//        }
        guard the3FieldsDict.count == 3 else {
            self.view.showSimpleAlert("Warning!!", "All Details are required", .warning)
            return
        }

        guard imagesDict.count == 3 else {
            self.view.showSimpleAlert("Warning!!", "Please upload the reqired Photos", .warning)
            return
        }
        
//        let allParameters : [String : Any] = [registerParameters + the3FieldsDict + imagesDict]

        registerParameters.merge(with: the3FieldsDict)
//        registerParameters.merge(with: imagesDict)
         let finalParameters =  registerParameters.merged(with: selectionDict)
        print("finalParameters : \(finalParameters)" )
        registerRequest.postRegisterationRequest(parameters: finalParameters, imageDict: imagesDict) { [weak self ] (data) in
            
            
            guard data.1 , let dataa = data.0 else {
                self?.view.showSimpleAlert("Error", data.2, .error)
                return
            }
//            print("that's the id : \(dataa.id)")
//            ad.saveUserLogginData(email: dataa.email, photoUrl: nil, uid: dataa.id, name: dataa.name)
//            print("that's the USER_ID : \(ad.USER_ID)")

    
        
//            DispatchQueue.main.async {
//                self?.view.isUserInteractionEnabled = false
//            }
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = false 
            }
        let alert = CDAlertView(title: "Done", message: "Welcome in Breeze,we will send u Message Shortly to fully activate your account", type: .success)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            alpha = 0
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true

                self?.navigationController?.popToRootViewController(animated: true)
              }
        }
        alert.hideAnimationDuration = 1.85
        alert.show()
//
        }
     }
    
    
    //    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    //    {
    //        return 44
    //    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        return headerView
    //    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction func dataSelectionBtns(_ sender: UIButton) {
    //
    //        self.dataSelectionView.alpha = 0
    //        self.listOfSelectionDataView.alpha = 1
    //             UIView.transition(from: self.listOfSelectionDataView, to: listOfSelectionDataView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
    //    }
    //    @IBAction func cancelDataSelection(_ sender: UIButton) {
    //
    //        self.dataSelectionView.alpha = 1
    //        self.listOfSelectionDataView.alpha = 0
    //        UIView.transition(from: self.listOfSelectionDataView, to: dataSelectionView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
    //    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RegisterDetailsListSegue" , let dest = segue.destination as? RegisterDataSelectionVC {
            dest.delegate = self
        }
    }
    
    
    
}


extension RegisterationDetailsVC : RegisterDetailsProtocoal {
    
    func sendCurrentDataSelection(_ data: [String : String]) {
         the3FieldsDict = data
        
    }
    
}







extension RegisterationDetailsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
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
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let tag =  currentBtntag else { return }
//        var  chosenImage = UIImage()
      let  chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        let assetPath = info[UIImagePickerControllerReferenceURL] as? NSURL
       // guard let _ =  assetPath?.absoluteString?.hasSuffix("JPG") else {
         //   self.view.showSimpleAlert("Erro", "Image has to be in JPG Format", .warning)
        //    return
     //   }
        //Test
        
        //            myImageView.contentMode = .scaleAspectFit //3
        //            myImageView.image = chosenImage //4
        let myThumb  = pickedImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))

//        guard  let imageData = chosenImage.jpeg(.lowest) else {
//            view.showSimpleAlert("Invalid Image Format", "", .warning)
//            return
//        }
//        print(imageData.count)
         switch tag {
        case 0 ://ProfileImage
            imagesDict["image"] = myThumb
            self.profilePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.profilePickingBtn.setTitle("", for: .normal)
        case 1 :
            imagesDict["licence"] = myThumb
            self.licensePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.licensePickingBtn.setTitle("", for: .normal)
        default :
            imagesDict["vehicle"] = myThumb
            self.VehicleInsurancePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.VehicleInsurancePickingBtn.setTitle("", for: .normal)
        }
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

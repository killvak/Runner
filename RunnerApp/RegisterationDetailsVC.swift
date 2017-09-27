//
//  RegisterationDetailsVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CDAlertView

class RegisterationDetailsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var profilePickingBtn: UIButton!
    @IBOutlet weak var licensePickingBtn: UIButton!
    @IBOutlet weak var VehicleInsurancePickingBtn: UIButton!
    
    let activityInd : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView()
        ai.color = .green
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    var selectionDict : [Int: Bool] = [:]
    var imagesDict : [Int : UIImage] = [:]
    let picker = UIImagePickerController()
    
    var currentBtntag : Int?
    var shifts = ["Morning","Afternoon","Evening","Late Night"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //yourButton.contentHorizontalAlignment = .left
        
        // Do any additional setup after loading the view.
        for i in 0...shifts.count - 1 {
            selectionDict[i] = true
            print(i)
        }
        picker.delegate = self
        
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
        cell.yesBtn.tag = indexPath.row
        cell.noBtn.tag = indexPath.row
        cell.yesBtn.addTarget(self, action: #selector(yesBtnSelected(_:)), for: .touchUpInside)
        cell.noBtn.addTarget(self, action: #selector(noBtnSelected(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil 
    }
    
    @IBAction func imageSelectionTrigger(sender : UIButton) {
        photoFromLibrary()
        
        currentBtntag = sender.tag
    }
    func yesBtnSelected(_ sender : UIButton) {
        
        selectionDict[sender.tag] = true
        handleCellBtnSelection(sender.tag, true)
        
        print("that's the selection List : \(selectionDict)")
    }
    
    func noBtnSelected(_ sender : UIButton) {
        
        selectionDict[sender.tag] = false
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
        
        let alert = CDAlertView(title: "Done", message: "Welcome in Breeze", type: .success)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            alpha = 0
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.679) {
                    
                    ad.reloadWithAnimation()
                    
                }
            }
        }
        alert.hideAnimationDuration = 0.88
        alert.show()
        
        
        //        ad.reload()
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
        print("Thats the current Data \(data)")
        
        
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
        
        guard let tag =  currentBtntag else { return }
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //            myImageView.contentMode = .scaleAspectFit //3
        //            myImageView.image = chosenImage //4
        
        imagesDict[tag] = chosenImage
        switch tag {
        case 0 :
            self.profilePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.profilePickingBtn.setTitle("", for: .normal)
        case 1 :
            self.licensePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.licensePickingBtn.setTitle("", for: .normal)
        default :
            self.VehicleInsurancePickingBtn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.VehicleInsurancePickingBtn.setTitle("", for: .normal)
        }
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//
//  NewOrderVC.swift
//  RunnerApp
//
//  Created by admin on 9/26/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import CoreLocation

class NewOrderVC: UIViewController , CLLocationManagerDelegate {
    
    @IBOutlet weak var modelViewNavBarHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var deliverCharges: UILabel!
    
    @IBOutlet weak var pickupAddressDetailsLbl: UILabel!
    
    @IBOutlet weak var confirmationSelectionView: UIView!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var orderStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var callCustomerTopConstraint: NSLayoutConstraint!// 20 > 50
    
    @IBOutlet weak var orderStateLbl: UILabel!
    @IBOutlet weak var orderStatusBar: UIView!
    @IBOutlet weak var declineBtnOL: UIButtonX!
    
    var orderDetails : OrderDataAndDetails?
    
    var orderIsActive = 0 { // 0 > pending request  , 1 > order in process  and  2 > order is done
        didSet {
            print("Order value is :\(orderIsActive)")
            guard viewAppeared else { return }
            print("viewAppeared/ Order value  is :\(orderIsActive)")

            orderActivationHandler()
        }
    }
    // the dest used
    var destLat : Double = 0
    var destLong : Double = 0
    // locations 
    var dropOffLat : Double = 0
    var dropOfflang : Double = 0
    var pickupLat : Double = 0
    var pickupLng : Double = 0
    
    ////
    var viewAppeared = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        if CLLocationManager.authorizationStatus() == .notDetermined {
        //            self.locationManager?.requestWhenInUseAuthorization()
        //        }
        //
        //        locationManager?.distanceFilter = kCLDistanceFilterNone
        //        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //        locationManager?.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isModal()  {
            self.modelViewNavBarHeight.constant = 45
        }
        
        if orderIsActive == 0  {
            orderIsNotActiveViewSetup()
        }
        
        orderActivationHandler()
        setData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewAppeared = true
//        orderActivationHandler()
    }
    
    func setData() {
        
        guard let data = orderDetails else {
           if  self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
           }else {
            self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        orderTitle?.text = data.order_details
        deliverCharges?.text = "\(data.total_price)"
        pickupAddressDetailsLbl?.text = data.pickup_address
        deliveryAddressLbl?.text = data.dropoff_address
        dropOffLat = data.dropoff_lat
        dropOfflang = data.dropoff_lng
        pickupLat = data.pickup_lat
        pickupLng = data.pickup_lng
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
//        if self.isModal()  {
//
//            print("is Model View")
//
            self.dismiss(animated: true, completion: nil)
//        }else {
//            print("is root VC")
//            ad.reload()
//        }
    }
    
    func orderActivationHandler() {
        
    
        
        
        switch orderIsActive {
        case 0 :
            self.orderStatusViewHeight.constant = 128
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.orderIsNotActiveViewSetup()
            }, completion: nil)
        case 1 :
            orderInProcessSetup()
        default : //2
            if  self.orderStatusViewHeight.constant == 128 {
                
                self.declineBtnOL.alpha = 0
                self.orderStatusBar.alpha = 0
                self.orderStateLbl.alpha = 1
                self.callCustomerTopConstraint.constant  = 50
                orderInProcessSetup()
                
            }else if self.orderStatusViewHeight.constant == 274.67 {
                
                self.view.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.45, animations: {
                    
                    self.declineBtnOL.alpha = 0
                    self.orderStatusBar.alpha = 0
                    self.orderStateLbl.alpha = 1
                    self.callCustomerTopConstraint.constant = 50
                    self.orderStatusViewHeight.constant = 200
                    self.view.layoutIfNeeded()
                }){(true) in
                    DispatchQueue.main.async {
                        self.view.isUserInteractionEnabled = true
                    }
                    }
                
            }
            
            
            
            
        }
    }
    
    func orderInProcessSetup() {
        
        self.orderStatusViewHeight?.constant = 274.67
        self.view.layoutIfNeeded()
        
        
        var offset = scrollView.contentOffset
        offset.y = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height
        scrollView.setContentOffset(offset, animated: true)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmationSelectionView.alpha = 0
            self.confirmationSelectionView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            
        },completion:nil)
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseInOut], animations: {
            self.orderStatusView.alpha = 1
            self.confirmationSelectionView.alpha = 0
            self.orderStatusView.transform = .identity
        }, completion: nil)
    }
    func  orderIsNotActiveViewSetup(){
        self.orderStatusView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        self.confirmationSelectionView.transform = .identity
        self.orderStatusView.alpha = 0
        self.confirmationSelectionView.alpha = 1
    }
    
    @IBAction func addressTrackerHandler(_ sender: UIButton) {
        
        if sender.tag == 0 { // Pickup Address
            destLat = pickupLat
            destLong = pickupLng
        }else { // Delivery Address
            destLat = dropOffLat
            destLong = dropOfflang
        }
        guard  let url = URL(string: "http://maps.apple.com/?saddr=\(self.lat),\(self.long)&daddr=\(destLat),\(destLong)&dirflg=d") else {
            return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func confirmationSelectionHandler(_ sender: UIButtonX) {
        if sender.tag == 0 { // accept
            orderIsActive = 1
        }else { // Decline
            orderIsActive = 2
        }
    }
    @IBAction func callCustomer(_ sender: UIButtonX) {
        let tele  = orderDetails?.phone
        if let phoneCallURL:URL = URL(string: "tel:\(tele)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Hey There", message: "Are you sure you want to call \n\(tele)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.openURL(phoneCallURL)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func declineOrderHandler(_ sender: UIButtonX) {
        orderIsActive = 2
        
//        declineAlertHandler()
       
    }
    
    func declineAlertHandler() {
        
        let alert = UIAlertController(title: "Cancel Order", message: "Cancel Order?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Order Cancelled by Restaurent", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("you have pressed the ok button")
        }))
        alert.addAction(UIAlertAction(title: "Order Cancelled by Me", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("you have pressed the ok button")
        }))
        alert.addAction(UIAlertAction(title: "Order Cancelled by User", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("you have pressed the ok button")
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil))
        
        //        alert.view.tintColor = .green
        self.present(alert, animated: true, completion: nil)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func tabBarButtonsHandler(_ sender: UIButton) {
        
     
//        switch sender.tag {
//        case 0:
//            let vc = RegisterVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 1:
//            let vc = HelpeMenuVC(nibName: "HelpeMenuVC", bundle: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        case 2: break
//        default: //3
//            break
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
        locationManager.stopUpdatingLocation()
        //        if ((error) != nil)
        //        {
        print("\(error)")
        //        }
    }
    var lat : Double = 0
    var long : Double = 0
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        lat = (coord.latitude)
        long = (coord.longitude)
        print(coord.latitude)
        print(coord.longitude)
        locationManager.stopUpdatingLocation()
        
    }
    
}


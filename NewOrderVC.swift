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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var deliverCharges: UILabel!
    
    @IBOutlet weak var pickupAddressDetailsLbl: UILabel!
 
    @IBOutlet weak var confirmationSelectionView: UIView!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var orderStatusViewHeight: NSLayoutConstraint!
    
    var orderIsActive = false {
        didSet {
            orderActivationHandler()
        }
    }
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
        if !orderIsActive {
         orderIsNotActiveViewSetup()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    
    func orderActivationHandler() {
        
        guard orderIsActive else {
            self.orderStatusViewHeight.constant = 128
            UIView.animate(withDuration: 0.3, animations: {
          self.orderIsNotActiveViewSetup()
             }, completion: nil)
            
            return
        }
        self.orderStatusViewHeight.constant = 274.67
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
        var destLat : Double = 0
        var destLong : Double = 0
        if sender.tag == 0 { // Pickup Address
            destLat = 27.839076
            destLong = 30.955353
        }else { // Delivery Address
            destLat = 30.977609
            destLong = 27.527618
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
            orderIsActive = true
        }else { // Decline
            
        }
    }
    @IBAction func callCustomer(_ sender: UIButtonX) {
        if let phoneCallURL:URL = URL(string: "tel:\(0201221515324)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Hey There", message: "Are you sure you want to call \n\(0201221515324)?", preferredStyle: .alert)
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
        orderIsActive = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

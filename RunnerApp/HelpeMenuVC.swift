//
//  HelpeMenuVC.swift
//  RunnerApp
//
//  Created by admin on 9/27/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class HelpeMenuVC: UIViewController {
    
    @IBOutlet weak var goOfflineBtnOL: UIButton!
    
    let userStatesRequest = M_UserRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         handleRunnerCurrentState()
    }
    
 
    
    @IBAction func menuBtnsHandler(_ sender: UIButton) {
 
    }
    
    
    @IBAction func langSwitch(_ sender: UISwitch) {/*
        var transition: UIViewAnimationOptions = .transitionFlipFromLeft
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
        rootviewcontroller.rootViewController = storyb.instantiateViewController(withIdentifier: "rootNav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
        UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
        }) { (finished) -> Void in
            
            
        }*/
    }
    @IBAction func backBtnAct(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func reload() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNav")
    }
    
    @IBAction func changeRunnerState(_ sender: UIButton) {
        
        guard let isOnline = UserDefaults.standard.value(forKey: "runnerIsOnLine") as? Bool , isOnline  else {
//            goOfflineBtnOL.setTitle("Go OFFLINE", for: .normal)
//            goOfflineBtnOL.backgroundColor =  .red
            sendUserChangeStatus(true)
//            UserDefaults.standard.setValue(true, forKey: "runnerIsOnLine")
//            ad.resumePostLocationServ()
            return
        }
        sendUserChangeStatus(false)
//        goOfflineBtnOL.setTitle("Go ONLINE", for: .normal)
//        goOfflineBtnOL.backgroundColor =  .green
//        UserDefaults.standard.setValue(false, forKey: "runnerIsOnLine")
//        ad.pausePostLocationServ()
      
    }
    
    
    
    func handleRunnerCurrentState( ) {
        
        guard let isOnline = UserDefaults.standard.value(forKey: "runnerIsOnLine") as? Bool , isOnline  else {
             goOfflineBtnOL.setTitle("Go ONLINE", for: .normal)
            goOfflineBtnOL.backgroundColor =  .green
             ad.pausePostLocationServ()
            return
        }
        goOfflineBtnOL.setTitle("Go OFFLINE", for: .normal)
        goOfflineBtnOL.backgroundColor =  .red
         ad.resumePostLocationServ()
        
    }
    
    func sendUserChangeStatus(_ state : Bool){
        
        userStatesRequest.postRunnerState(state, completed: { [weak self ] (statee, sms) in
            
            guard statee else {
                self?.view.showSimpleAlert("Error", sms, .error)
                return }
            UserDefaults.standard.setValue(state, forKey: "runnerIsOnLine")
            DispatchQueue.main.async {
                self?.handleRunnerCurrentState( )
            }
        })
        
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

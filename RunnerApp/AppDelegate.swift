//
//  AppDelegate.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import OneSignal
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , OSSubscriptionObserver {
    
    var window: UIWindow?
    private let oneSignalRequest = M_UserRequest()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        L102Localizer.DoTheMagic()
        //        print("thats user id : \(ad.USER_ID)...")
        if  isUserLoggedIn() {
            
            
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //
            //            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
            //
            //            self.window?.rootViewController = initialViewController
            //            self.window?.makeKeyAndVisible()
            
            /*
             OneSignal.initWithLaunchOptions(launchOptions, appId: "ec902011-ea98-4b6e-95f7-f040df6a2d49", handleNotificationReceived: { (notification) in
             //            print("Received Notification - \((notification?.payload.notificationID) )")
             }, handleNotificationAction: { result in
             
             // This block gets called when the user reacts to a notification received
             let payload: OSNotificationPayload = result!.notification.payload
             var fullMessage = payload.body
             
             //Try to fetch the action selected
             if let additionalData = payload.additionalData, let actionSelected = additionalData["actionSelected"] as? String  {
             fullMessage =  fullMessage ?? "" + "\nPressed ButtonId:\(actionSelected)"
             }
             print("fullMessage = \(String(describing: fullMessage))")
             }, settings: [kOSSettingsKeyAutoPrompt : true,
             kOSSettingsKeyInFocusDisplayOption: OSNotificationDisplayType.notification.rawValue])
             
             
             OneSignal.add(self as OSSubscriptionObserver)
             */
            oneSignalSetup(launchOptions)
        
//            checkIfTokenSent()
        }else {
            let nav1 = UINavigationController()
            nav1.navigationBar.tintColor = .black
            let initialViewController = LoginVC(nibName: "LoginVC", bundle: nil)
            nav1.viewControllers = [initialViewController]
            
            let frame = UIScreen.main.bounds
            window = UIWindow(frame: frame)
            
            window?.rootViewController = nav1
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    

    
    func checkIfTokenSent() {
        guard let oneSignalID =  UserDefaults.standard.value(forKey: "hasSentPlayerID") as? Bool , oneSignalID  else {
            guard  let playerID = UserDefaults.standard.value(forKey: "oneSignalToken") as? String  else { return }
            sendPlayerID(playerID)
            return
        }
    }
    
    //
    
    // After you add the observer on didFinishLaunching, this method will be called when the notification subscription property changes.
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
         //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            notificationSettings(playerId)
            self.sendPlayerID(playerId)
         }
    }
    
    func sendPlayerID(_ playerId : String) {
        
        oneSignalRequest.postOneSignalPlayerID(playerId, completed: { (status, sms) in
            
            guard status else {
                UserDefaults.standard.setValue(false, forKey: "hasSentPlayerID")
                print("failed to send playerID : \(sms)")
                return
            }
            UserDefaults.standard.setValue(true, forKey: "hasSentPlayerID")
            
            print("√√ sent playerID : \(sms)")
            
        })

    }
    
    func notificationSettings(_ playerId : String) {
        guard let userID = UserDefaults.standard.value(forKey: "userId") as? Int else {
            UserDefaults.standard.setValue(nil, forKey: "oneSignalToken")
            print("⚠️No userID Found  ❌ ");
            return }
        
        
        if     UserDefaults.standard.value(forKey: "oneSignalToken") as? String != playerId {
            print("✅Updating Token ✳️found  userId: \(String(describing: UserDefaults.standard.value(forKey: "userId") as? String))\n ,FCMToken \(String(describing: UserDefaults.standard.value(forKey: "oneSignalToken") as? String))\n, so updating it with refreshedToken \(playerId)\n and userID : \(userID)")
            
            //            let userFCM = MUserData()
            //            userFCM.userFCMToken(userID: userID, token: refreshedToken, completed: { (state,sms) in
            //
            //                if state {
            UserDefaults.standard.setValue(playerId, forKey: "oneSignalToken")
            print("✅Updated Token  ✅ ")
            //
            //                }
            //            })
        }else {
            print("❌ Won't Update Token,it's Already in UserDefauls⚠️That's userId: \(String(describing: UserDefaults.standard.value(forKey: "userId") as? Int))\n ,♎️FCMTokenNSDefault  📴📳\(String(describing: UserDefaults.standard.value(forKey: "oneSignalToken") as? String)) 📴📳\n, ♎️updatedInstanceID token: 📴📳\(playerId)📴📳\n")
        }
        
    }
    
    func oneSignalSetup(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            guard let result = result else { print("Öne signal result is EQUAL to nil ");return }
            let payload: OSNotificationPayload = result.notification.payload
            
            var fullMessage = payload.body
            print("Message = \(fullMessage)")
            
            if payload.additionalData != nil {
                if payload.title != nil {
                    let messageTitle = payload.title
                    print("Message Title = \(messageTitle!)")
                }
 
                 let additionalData = payload.additionalData
                if additionalData?["actionSelected"] != nil {
                    fullMessage = fullMessage ?? "" + "\nPressed ButtonID: \(String(describing: additionalData?["actionSelected"]))"
                }
            }
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
                                     kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "a060954f-ba6c-44aa-a0dc-2c19fff6c9fc",
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        //test
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
//        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        
//        let hasPrompted = status.permissionStatus.hasPrompted
//        print("hasPrompted = \(hasPrompted)")
//        let userStatus = status.permissionStatus.status
//        print("userStatus = \(userStatus)")
        
//        let isSubscribed = status.subscriptionStatus.subscribed
//        print("isSubscribed = \(isSubscribed)")
//        let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
//        print("userSubscriptionSetting = \(userSubscriptionSetting)")
//        let userID = status.subscriptionStatus.userId
//        print("userID = \(String(describing: userID))")
//        let pushToken = status.subscriptionStatus.pushToken
//        print("pushToken = \(String(describing: pushToken))")
        
        //@End Test
        
        
        OneSignal.add(self as OSSubscriptionObserver)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard
            let aps = userInfo[AnyHashable("custom")] as? NSDictionary,
        let orderData = aps["a"] as? NSDictionary,
        let user_id = orderData["user_id"] as? Int
             else {
                // handle any error here
                return
        }
        
        /*
         { "notification": {
         "body”:”Test Push Notification (42)”,
         "node":"1233837”
         
         }, "priority":10,
         "content-available":true
         
         }

 */
   
        let orderDetails  = OrderDataAndDetails( JSON(orderData))
        print("Title: \(orderData)")
//        if(application.applicationState == .active) {
        var viewCon : NewOrderVC!
            //app is currently active, can update badges count here
        guard let rootViewController = self.window?.rootViewController as? UINavigationController else {
            return
        }
        if application.applicationState == UIApplicationState.inactive || application.applicationState == UIApplicationState.background{
                //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
           viewCon = self.window!.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "NewOrderVC") as! NewOrderVC

//                 rootViewController.present(viewController, animated: true, completion: nil)
        }else {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        viewCon  = mainStoryboardIpad.instantiateViewController(withIdentifier: "NewOrderVC") as! NewOrderVC
//        self.window?.rootViewController?.navigationController?.pushViewController(initialViewControlleripad, animated: true )
        }
            viewCon.orderDetails = orderDetails
        self.window?.rootViewController?.present(viewCon, animated: true, completion: nil)
        print("data is here and u r active SIR ")
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here

 //        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func saveUserLogginData(email:String?,photoUrl : String? , uid : Int?,name:String?) {
        //        print("saving User Data email: \(String(describing: email)) , photoUrl: \(String(describing: photoUrl)),uid: \(String(describing: uid)),  , photoUrl: \(String(describing: name))")
        if email != "default" {
            if   let email = email   {
                UserDefaults.standard.setValue(email, forKey: "userEmail")
            }else{
                UserDefaults.standard.setValue(nil, forKey: "userEmail")
                
            }
        }
        if photoUrl != "default" {
            
            if  let photo = photoUrl {
                UserDefaults.standard.setValue(photo, forKey: "profileImage")
                //                print("saing this photo : \(photo)")
            }else {
                UserDefaults.standard.setValue(nil, forKey: "profileImage")
            }
        }
        if uid != -1 {
            
            if  let uid = uid {
                UserDefaults.standard.setValue(uid, forKey: "userId")
            }else {
                UserDefaults.standard.setValue(nil, forKey: "userId")
                UserDefaults.standard.setValue(nil, forKey: "oneSignalToken")
            }
        }
        if name != "default" {
            
            if let name = name {
                UserDefaults.standard.setValue(name, forKey: "usreName")
            }else {
                UserDefaults.standard.setValue(nil, forKey: "usreName")
            }
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if (UserDefaults.standard.value(forKey: "userId") != nil) {
            return true
        }else {
            guard let _ = UserDefaults.standard.value(forKey: "usreName") as? String else {
                return false
            }
            saveUserLogginData(email: nil, photoUrl: nil, uid: nil, name: nil)
            return false
        }
    }
    func reload() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNav")
    }
    
    func reloadWithAnimation() {
        //        self.view.addSubview(self.activityInd)
        //        self.activityInd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //        self.activityInd.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        var transition: UIViewAnimationOptions = .transitionFlipFromLeft
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        if isUserLoggedIn() {
            let storyb = UIStoryboard(name: "Main", bundle: Bundle.main)
            rootviewcontroller.rootViewController = storyb.instantiateViewController(withIdentifier: "rootNav")
        }else {
            let nav1 = UINavigationController()
            nav1.navigationBar.tintColor = .black
            let initialViewController = LoginVC(nibName: "LoginVC", bundle: nil)
            nav1.viewControllers = [initialViewController]
            rootviewcontroller.rootViewController = nav1
            
        }
        
        
        
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
        UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
        }) { (finished) -> Void in
            
            
        }
        
    }
    
    var USER_ID :Int   {
        guard  let userID = UserDefaults.standard.value(forKey: "userId") as? Int else {
            //        print("error fetching userId from NSUserD.userId")
            return 0
        }
        return userID
    }
}
let ad = UIApplication.shared.delegate as! AppDelegate


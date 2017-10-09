//
//  M_UserRequest.swift
//  RunnerApp
//
//  Created by admin on 9/28/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class M_UserRequest  {
    
    
    //(completed : @escaping ([RepoVars]?) ->())
    private  let source = Constants.API.URLS()
    private   let parSource = Constants.API.Parameters()
    
    func postRegisteredEmail( email : String  ,completed : @escaping ( Bool,String)->()) {
        
        let url = source.POST_Email_Existance
        print("URL: is postRegisterRequest RL : \(url)")
        let parameters : Parameters = [
            "email":email ,
            ]
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                //                let data = User_DataModel(json[parm.user])
                let statusCode = json[parm.status].intValue == 0 ? true : false  // backEnd state is flipped
                let sms = json[parm.message].stringValue
                completed(  statusCode ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                //                              print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
                //
                completed( false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    func postForgotPassword( email : String  ,completed : @escaping ( Bool,String)->()) {
        
        let url = source.POST_Email_Existance
        print("URL: is postRegisterRequest RL : \(url)")
        let parameters : Parameters = [
            "email":email ,
            ]
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    print(response.result.error)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json[parm.message].string != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                //                              print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
                //
                completed( false,"")
                break
            }
        }
    }
    
    private  let sessionManager : SessionManager = {
        let con = URLSessionConfiguration.default
        con.timeoutIntervalForResource = TimeInterval(10)
        con.timeoutIntervalForRequest = TimeInterval(10)
        return  Alamofire.SessionManager(configuration: con)
    }()
    func postLoginRequest( email : String , password : String  ,completed : @escaping (User_DataModel?,Bool,String)->()) {
        
        let url = source.POST_LOGIN
        print("URL: is POST_LOGIN URL : \(url)")
        let parameters : Parameters = [
            "email":email ,
            "password" : password,
            ]
        print(parameters)
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForResource = TimeInterval(60)
        //        configuration.timeoutIntervalForRequest = TimeInterval(60)
        //
        //        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let data = User_DataModel(json[parm.user])
                let statusCode = json[parm.error][parm.status_code].intValue
                let status = data.email != "" ? true : false
                print("that's \(data.email)that's status \(statusCode)")
                let sms = statusCode == 400 ? "Email is already exists" : "Something Went Wrong,Please try again."
                completed( data, status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
                //
                completed(nil  , false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    
    
    
    func postRegisterationRequest(  parameters : [String : Any] ,   imageDict : [String:UIImage],completed : @escaping (User_DataModel?,Bool,String)->()) {
        
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in imageDict{
                if let imageData = UIImageJPEGRepresentation(value, 1) {
                    //                    multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                    multipartFormData.append(imageData, withName: key, fileName: "swift_file.jpg", mimeType: "image/jpg")
                }
            }
            for (key, value) in parameters {
                //                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key as String)
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to:source.POST_Registeration, method: .post, headers: source.HEADER)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                //                upload.uploadProgress(closure: { (Progress) in
                //                    print("Upload Progress: \(Progress.fractionCompleted)")
                //                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print("original URL request\n\(response.request)\n\n")  // original URL request
                    print("response \n:\(response.response)\n\n") // URL response
                    print("data :\n\(response.data)\n\n")      // server data
                    print("result :\n\(response.result)\n\n")    // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    guard  let value = response.result.value else {
                        return
                    }
                    let json = JSON( value) // SwiftyJSON
                    print("that;s json \(json)")
                    
                    let parm = Constants.API.Parameters()
                    
                    let data = User_DataModel(json[parm.message][parm.user])
                    let statusCode = json[parm.message][parm.user][parm.id].int
                    let status = statusCode == nil ? false : true
                    let sms = json[parm.message]["message"].string ?? json[parm.error]["message"].stringValue
                    print("that's timeline : \(data.timeSlots) email : \(data.email) /n id : \(data.id)that's status \(statusCode) status \(status) sms: \(sms)////")
                    
                    completed( data, status ,sms)
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                completed(nil,false,self.parSource.requestHasFailed)
            }
            
        }
    }
    
    
    func getProfileDataByIdRequst(  completed : @escaping (User_DataModel?,Bool,String)->()) {
        
        let url = source.GET_RUNNER_PROFILE_BY_ID + "\(ad.USER_ID)"
        print("URL: is GET_RUNNER_PROFILE_BY_ID URL : \(url)")
        
        
        sessionManager.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    print(response.result.error?.localizedDescription)
                    completed(nil  , false,self.parSource.requestHasFailed)
                    
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let data = User_DataModel(json[parm.data])
                let statusCode = json[parm.error][parm.status_code].intValue
                let status = data.email != "" ? true : false
                //                print("that's \(data.email)that's status \(statusCode)")
                let sms =   json[parm.error]["message"].string ?? "Done"
                print("that's timeline : \(data.timeSlots) email : \(data.email) /n id : \(data.id)that's status \(statusCode) status \(status) sms: \(sms)////")
                
                completed( data, status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
                //
                completed(nil  , false,self.parSource.requestHasFailed)
                break
            }
        }
    }//file:///Users/admin/Documents/RunnerApp/RunnerApp/M_UserRequest.swift
    
    
    func getHomePageData(_ pageNum : Int , _ numOfItems : Int, completed : @escaping (HomePageData?,Bool,String)->()) {
                let url = source.Get_HomePage + "/4/20" + "?page=\(pageNum)"
        
//        let url = source.Get_HomePage + "/\(ad.USER_ID)/\(numOfItems)" + "?page=\(pageNum)"
        print("URL: is getHomePageData URL : \(url)")
        
        
        sessionManager.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    print(response.result.error?.localizedDescription as Any)
                    completed(nil  , false,self.parSource.requestHasFailed)
                    
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                                print("that is  getMenuData getting the data Mate : %@", response.result.value as Any)
                let parm = Constants.API.Parameters()
                let data = json[parm.data]
                let homeData = HomePageData(json)
                var orderDataAndDetails = [OrderDataAndDetails]()
                
                for (_ , json ) in data {
                    let x = OrderDataAndDetails(json)
                    x.placeDetails = PlaceDetails(data["place_id"])
                    let itemsData =  data["items"]
                    var items = [ItemsDetails]()
                    for item in itemsData {
                        items.append(ItemsDetails(item.1))
                    }
                    x.itemDetails = items
                    orderDataAndDetails.append(x)
                }

                homeData.ordesArray = orderDataAndDetails
                if let test = homeData.ordesArray , test.count >= 1  {
                print("that's homeData : \(test[0].userID)  placeDetails : \(test[0].placeDetails?.placeID) ")
                }
                //                let statusCode = json[parm.error][parm.status_code].intValue
                let status = orderDataAndDetails.count >= 1 ? true : false
                //                print("that's \(data.email)that's status \(statusCode)")
                let sms =   json[parm.error]["message"].string ?? "Done"
                //                print("that's timeline : \(data.timeSlots) email : \(data.email) /n id : \(data.id)that's status \(statusCode) status \(status) sms: \(sms)////")
                
                completed( homeData, status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("that is fail i n getting the Home  data Mate : \(response.result.error?.localizedDescription)")
                //
                completed(nil  , false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    func postOneSignalPlayerID( _ playerID : String, completed : @escaping ( Bool,String)->()) {
        
        let url = source.POST_ONESIGNAL_PLAYID
        print("URL: is POST_ONESIGNAL_PLAYID URL : \(url)")
        let parameters : Parameters = [
            "user_id" : ad.USER_ID,
            "role_id": "3",
            "player_id" : playerID
            
        ]
        //        print(parameters)
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForResource = TimeInterval(60)
        //        configuration.timeoutIntervalForRequest = TimeInterval(60)
        //
        //        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json["updated"].int != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                //                print("that's \(status)that's status \(sms)")
                
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
                //
                completed(     false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    func postSendUserLocation(_ lat : Double ,_ lng : Double , completed : @escaping ( Bool,String)->()) {
        
        let url = source.POST_UPDATE_USer_LOCATION
        print("URL: is POST_UPDATE_USer_LOCATION URL : \(url)")
        let parameters : Parameters = [
            "runner_id":ad.USER_ID,
            "lat":"\(lat)",
            "lng":"\(lng)"
            
        ]
        //        print(parameters)
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForResource = TimeInterval(60)
        //        configuration.timeoutIntervalForRequest = TimeInterval(60)
        //
        //        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json[parm.message].string != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                print("that's \(status)that's status \(sms)")
                
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("Failer: \(String(describing: response.result.error?.localizedDescription))")
                //
                completed(     false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    func postRunnerState(_ runnerWillGoOnLine : Bool ,  completed : @escaping ( Bool,String)->()) {
        
        let url = runnerWillGoOnLine ? source.POST_GoOnline : source.POST_GoOffLine
        print("URL: is postRunnerState URL : \(url)")
        let parameters : Parameters = [
            "id":ad.USER_ID,
            ]
        
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json[parm.message].string != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                print("that's \(status)that's status \(sms)")
                
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("Failer: \(String(describing: response.result.error?.localizedDescription))")
                //
                completed(     false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
    func postRunnerAcceptOrder(_ orderID : Int ,  completed : @escaping ( Bool,String)->()) {
        
        let url = source.POST_Runner_Accept_Order
        print("URL: is POST_Runner_Accept_Order URL : \(url)")
        let parameters : Parameters = [
            "runner_id" : ad.USER_ID,
            "order_id" : orderID
            
        ]
        
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json[parm.message].string != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                print("that's \(status)that's status \(sms)")
                
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("Failer: \(String(describing: response.result.error?.localizedDescription))")
                //
                completed(     false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    func post_Normal_Request(_ url:Constants.API.URLS_Post_Enum , _ parameters : [String : Any] ,  completed : @escaping ( Bool,String)->()) {
        
        let url = url.stringValue()
        print("URL is : \(url)")
        print("par, is : \(parameters)")
        
        
        sessionManager.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    //                    print(response.result.error?.localizedDescription)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let status = json[parm.message].string != nil ? true : false
                let sms = json[parm.message].string ?? json[parm.error][parm.message].stringValue
                print("that's \(status)that's status \(sms)")
                
                completed(  status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("Failer: \(String(describing: response.result.error?.localizedDescription))")
                //
                completed(     false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    func getRunnerOrders(  _ numOfItems : Int, completed : @escaping ([OrderDataAndDetails]?,Bool,String)->()) {
        //        let url = source.Get_HomePage + "/4/20" + "?page=\(pageNum)"
        
        let url = source.GET_Runner_Complete_Orders + "/\(ad.USER_ID)/\(numOfItems)"
        print("URL: is getRunnerOrders URL : \(url)")
        
        
        sessionManager.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
            //            print(response.result)
            switch(response.result) {
            case .success(_):
                guard response.result.error == nil, let value = response.result.value  else {
                    
                    // got an error in getting the data, need to handle it
                    //                    print("error fetching data from url")
                    print(response.result.error?.localizedDescription as Any)
                    completed(nil  , false,self.parSource.requestHasFailed)
                    
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                //                print("that is  getMenuData getting the data Mate : %@", response.result.value as Any)
                let parm = Constants.API.Parameters()
                let data = json[parm.data]
                var orderDataAndDetails = [OrderDataAndDetails]()
                for (_ , json ) in data {
                    let x = OrderDataAndDetails(json)
                    x.placeDetails = PlaceDetails(data["place_id"])
                    let itemsData =  data["items"]
                    var items = [ItemsDetails]()
                    for item in itemsData {
                        items.append(ItemsDetails(item.1))
                    }
                    x.itemDetails = items
                    orderDataAndDetails.append(x)
                }
                //                let statusCode = json[parm.error][parm.status_code].intValue
                let status = orderDataAndDetails.count >= 1 ? true : false
                //                print("that's \(data.email)that's status \(statusCode)")
                let sms =   json[parm.error]["message"].string ?? "Done"
                //                print("that's timeline : \(data.timeSlots) email : \(data.email) /n id : \(data.id)that's status \(statusCode) status \(status) sms: \(sms)////")
                
                completed( orderDataAndDetails, status ,sms)
                break
                
            case .failure(_) :
                //                             if let data = response.data {
                //                               let json = String(data: data, encoding: String.Encoding.utf8)
                //                                 print("Failure Response: \(json)")
                //                              }
                print("that is fail i n getting the Home  data Mate : \(response.result.error?.localizedDescription)")
                //
                completed(nil  , false,self.parSource.requestHasFailed)
                break
            }
        }
    }
    
    
}


class User_DataModel {
    private   let source = Constants.API.Parameters()
    
    //[
    private var _id :Int?
    
    private var _name  : String?
    private var _email : String?
    private var _refered_by : Int?
    private var _phone : String?
    private var _points : Int?
    private var _transportation : String?
    private var _work_hours : String?
    private var _morning : Int?
    private var _afternoon : Int?
    private var _evening : Int?
    private var _late_night : Int?
    
    
    //]
    
    //[
    
    var timeSlots : String {
        var finalString = ""
        let array = ["Morning":_morning,"Afternoon":_afternoon,"Evening":_evening,"Night":_late_night]
        
        for (key ,value) in array {
            //            print(" key \(key) value in \(value)")
            guard value == 1 else { continue }
            finalString.append("| \(key) | ")
        }
        return finalString
    }
    var name : String {
        guard let x = _name else { return "" }
        return x
    }
    
    
    var id : Int {
        guard let x = _id else { return 0 }
        return x
    }
    var email : String {
        guard let x = _email else { return "" }
        return x
    }
    var refered_by : Int {
        guard let x = _refered_by else { return 0 }
        return x
    }
    var phone : String {
        guard let x = _phone else { return "" }
        return x
    }
    var points : Int {
        guard let x = _points else { return 0 }
        return x
    }
    var transportation : String {
        guard let x = _transportation else { return "" }
        return x
    }
    //    var work_hours : String {
    //        guard let x = _work_hours else { return "" }
    //        return x
    //    }
    init(_ jsonData : JSON) {
        self._name = jsonData[source.name].stringValue
        self._email = jsonData[source.email].stringValue
        self._id = jsonData[source.id].intValue
        self._refered_by = jsonData[source.refered_by].intValue
        self._email = jsonData[source.email].stringValue
        self._points = jsonData[source.points].intValue
        self._transportation = jsonData[source.transportation].stringValue
        self._morning = jsonData[source.morning].intValue
        self._afternoon = jsonData[source.afternoon].intValue
        self._evening = jsonData[source.evening].intValue
        self._late_night = jsonData[source.late_night].intValue
        
        
    }
    
    
}

/*
 {
 "message": "order created successfully",
 "order": {
 "user_id": 5,
 "pickup_lat": "24.668010",
 "pickup_lng": "46.664042",
 "pickup_address": "4009-4067 King Khalid Rd, Umm Al Hamam Al Sharqi, Riyadh 12721, Arabia Saudyjska",
 "dropoff_lat": "24.666362",
 "dropoff_lng": "46.630375",
 "dropoff_address": "8412, Al Hada, Riyadh 12912 3380, Arabia Saudyjska",
 "order_details": "i want to deliver some food",
 "phone": "010000373746",
 "total_price": 15,
 "distance": "6,1 km",
 "expected_time": "11 min",
 "updated_at": "2017-10-03 17:58:32",
 "created_at": "2017-10-03 17:58:32",
 "id": 110
 }
 }
 
 "id": 1,
 "menu_id": 1,
 "page_id": 3,
 "name_ar": "item 1",
 "desc_en": "item ",
 "desc_ar": "item",
 "name_en": "item 1",
 "price": "22",
 "image": "http://via.placeholder.com/350x150",
 "created_at": null,
 "updated_at": null
 */

class ItemsDetails {
    private   let source = Constants.API.Parameters()
    
    private var _id : Int?
   
    
    private var _image  : String?
    private var _name_ar  : String?
    private var _name_en  : String?
    private var _desc_ar  : String?
    private var _desc_en  : String?
    private var _price  : String?

 
    
    //[
 
    
    
    
    var imageLink : String {
        guard let x = _image else { return "" }
        return x
    }
    var price : String {
        guard let x = _price else { return "" }
        return x
    }
    //    var name_ar : String {
    //        guard let x = _name_ar else { return "" }
    //        return x
    //    }
    //    var name_en : String {
    //        guard let x = _name_en else { return "" }
    //        return x
    //    }
    var name : String {
        guard let x =  L102Language.currentAppleLanguage() == "en"  ? _name_en : _name_ar else { return "" }
        return x
    }
    
    //    var desc_ar : String {
    //        guard let x = _desc_ar else { return "" }
    //        return x
    //    }
    //    var desc_en : String {
    //        guard let x = _desc_en else { return "" }
    //        return x
    //    }
    var desc : String {
        guard let x =  L102Language.currentAppleLanguage() == "en"  ? _desc_en : _desc_ar else { return "" }
        return x
    }
   
    
    init(_ jsonData : JSON) {
        self._id = jsonData[source.id].intValue
        self._image = jsonData[source.image].stringValue
        self._name_ar = jsonData[source.name_ar].stringValue
        self._name_en = jsonData[source.name_en].stringValue
        self._desc_ar = jsonData[source.desc_ar].stringValue
        self._desc_en = jsonData[source.desc_en].stringValue
        self._price = jsonData[source.total_price].stringValue

        
        
    }
    
    
}


class OrderDataAndDetails {
    private   let source = Constants.API.Parameters()
    
    //[
    private var _id :Int?
    //For Home Data
    private var _userID :Int?
    private var _order_status :Int?
    private var _paid :Int?
    private var _cancelled_by :Int?
    private var _created_at :String?
    
    // @end For Home data
    private var _pickup_lat  : String?
    private var _pickup_lng  : String?
    private var _pickup_address  : String?
    private var _dropoff_lat  : String?
    private var _dropoff_lng  : String?
    private var _dropoff_address  : String?
    private var _order_details  : String?
    private var _phone : String?
    private var _distance  : String?
    private var _total_price  : Int?
    private var _expected_time  : String?
    
    var placeDetails : PlaceDetails?
    var itemDetails : [ItemsDetails]?
    //]
    
    //[
    //Home vars
    var  userID : Int {
        guard let x = _userID else { return 0 }
        return x
    }
    var  order_status : Int {
        guard let x = _order_status else { return 0 }
        return x
    }
    var  paid : Int {
        guard let x = _paid else { return 0 }
        return x
    }
    var  cancelled_by : Int {
        guard let x = _cancelled_by else { return 0 }
        return x
    }
    var created_at : String {
        guard let x = _created_at else { return "" }
        return x
    }
    
    //@end
    var orderID : Int {
        guard let x = _id else { return 0 }
        return x
    }
    
    var pickup_lat : Double {
        guard let x = _pickup_lat , let lat = Double(x) else { return 0 }
        return lat
    }
    
    var pickup_lng : Double {
        guard let x = _pickup_lng , let lng = Double(x) else { return 0 }
        return lng
    }
    var pickup_address : String {
        guard let x = _pickup_address else { return "" }
        return x
    }
    var dropoff_lat : Double {
        guard let x = _dropoff_lat , let lat = Double(x) else { return 0 }
        return lat
    }
    var dropoff_lng : Double {
        guard let x = _dropoff_lng , let lng = Double(x) else { return 0 }
        return lng
    }
    var dropoff_address : String {
        guard let x = _dropoff_address else { return "" }
        return x
    }
    var order_details : String {
        guard let x = _order_details else { return "" }
        return x
    }
    var phone : String {
        guard let x = _phone else { return "" }
        return x
    }
    var distance : String {
        guard let x = _distance else { return "" }
        return x
    }
    var total_price : Int {
        guard let x = _total_price else { return -1 }
        return x
    }
    var expected_time : String {
        guard let x = _expected_time else { return "" }
        return x
    }
    
    
    
    //    var work_hours : String {
    //        guard let x = _work_hours else { return "" }
    //        return x
    //    }
    init(_ jsonData : JSON) {
        self._id = jsonData[source.id].intValue
        self._pickup_lat = jsonData[source.pickup_lat].stringValue
        self._pickup_lng = jsonData[source.pickup_lng].stringValue
        self._pickup_address = jsonData[source.pickup_address].stringValue
        self._dropoff_lat = jsonData[source.dropoff_lat].stringValue
        self._dropoff_lng = jsonData[source.dropoff_lng].stringValue
        self._dropoff_address = jsonData[source.dropoff_address].stringValue
        self._order_details = jsonData[source.order_details].stringValue
        self._phone = jsonData[source.phone].stringValue
        self._distance = jsonData[source.distance].stringValue
        self._total_price = jsonData[source.total_price].intValue
        self._expected_time = jsonData[source.expected_time].stringValue
        
        self._userID = jsonData[source.user_id].intValue
        self._order_status = jsonData[source.order_status].intValue
        self._paid = jsonData[source.paid].intValue
        self._cancelled_by = jsonData[source.cancelled_by].intValue
        self._created_at = jsonData[source.created_at].stringValue
    }
    
}

/*\
 "from": 1,
 "last_page": 2,
 "next_page_url": "http://192.168.1.140/breeze/api/v1/runner/home/72/20?page=2",
 "path": "http://192.168.1.140/breeze/api/v1/runner/home/72/20",
 "per_page": "20",
 "prev_page_url": null,
 "to": 20,
 "total": 33,
 "runner_rate": 0,
 "orders_count": 2
 */

class PlaceDetails {
    private   let source = Constants.API.Parameters()
    
    private var _id : Int?
    private var _country_id : Int?
    private var _city_id : Int?
    private var _district_id : Int?
    private var _category_id : Int?
    
    private var _image  : String?
    private var _name_ar  : String?
    private var _name_en  : String?
    private var _desc_ar  : String?
    private var _desc_en  : String?
    
    private var _cuisines  : String?
    private var _address  : String?
    private var _delivery_time  : String?
    private var _open_at  : String?
    private var _close_at  : String?
    private var _latitude  : String?
    private var _longitude  : String?
    
    private var _total : Int?
    private var _runner_rate : Int?
    private var _orders_count : Int?
    
    //[
    var ordesArray : [OrderDataAndDetails]?
    
    
    
    var placeID : Int {
        guard let x = _id else { return 0 }
        return x
    }
    var country_id : Int {
        guard let x = _country_id else { return 0 }
        return x
    }
    var city_id : Int {
        guard let x = _city_id else { return 0 }
        return x
    }
    var district_id : Int {
        guard let x = _district_id else { return 0 }
        return x
    }
    var category_id : Int {
        guard let x = _category_id else { return 0 }
        return x
    }
    var imageLink : String {
        guard let x = _image else { return "" }
        return x
    }
    
//    var name_ar : String {
//        guard let x = _name_ar else { return "" }
//        return x
//    }
//    var name_en : String {
//        guard let x = _name_en else { return "" }
//        return x
//    }
    var name : String {
        guard let x =  L102Language.currentAppleLanguage() == "en"  ? _name_en : _name_ar else { return "" }
        return x
    }
    
//    var desc_ar : String {
//        guard let x = _desc_ar else { return "" }
//        return x
//    }
//    var desc_en : String {
//        guard let x = _desc_en else { return "" }
//        return x
//    }
    var desc : String {
        guard let x =  L102Language.currentAppleLanguage() == "en"  ? _desc_en : _desc_ar else { return "" }
        return x
    }
    var cuisines : String {
        guard let x = _cuisines else { return "" }
        return x
    }
    var address : String {
        guard let x = _address else { return "" }
        return x
    }
    var delivery_time : String {
        guard let x = _delivery_time else { return "" }
        return x
    }
    var open_at : String {
        guard let x = _open_at else { return "" }
        return x
    }
    var close_at : String {
        guard let x = _close_at else { return "" }
        return x
    }
    var latitude : String {
        guard let x = _latitude else { return "" }
        return x
    }
    var longitude : String {
        guard let x = _longitude else { return "" }
        return x
    }
    
    
    init(_ jsonData : JSON) {
        self._id = jsonData[source.id].intValue
        self._image = jsonData[source.image].stringValue
        self._name_ar = jsonData[source.name_ar].stringValue
        self._name_en = jsonData[source.name_en].stringValue
        self._desc_ar = jsonData[source.desc_ar].stringValue
        self._desc_en = jsonData[source.desc_en].stringValue
        self._cuisines = jsonData[source.cuisines].stringValue
        self._address = jsonData[source.address].stringValue
        self._delivery_time = jsonData[source.delivery_time].stringValue
        self._open_at = jsonData[source.open_at].stringValue
        self._close_at = jsonData[source.close_at].stringValue
        self._latitude = jsonData[source.latitude].stringValue
        self._longitude = jsonData[source.longitude].stringValue
        
        
    }
    
    
}




class HomePageData {
    private   let source = Constants.API.Parameters()
    
    private var _from : Int?
    private var _last_page : Int?
    
    private var _per_page  : String?
    private var _total : Int?
    private var _runner_rate : Int?
    private var _orders_count : Int?
    
    //[
    var ordesArray : [OrderDataAndDetails]?
 
    
    var from : Int {
        guard let x = _from else { return 0 }
        return x
    }
    var lastPage : Int {
        guard let x = _last_page else { return 0 }
        return x
    }
    var perPage : String {
        guard let x = _per_page else { return "" }
        return x
    }
    var totalOrders : Int {
        guard let x = _total else { return 0 }
        return x
    }
    var runnerRate : Int {
        guard let x = _runner_rate else { return 0 }
        return x
    }
    
    //    var work_hours : String {
    //        guard let x = _work_hours else { return "" }
    //        return x
    //    }
    init(_ jsonData : JSON) {
        self._from = jsonData[source.from].intValue
        self._last_page = jsonData[source.lastPage].intValue
        self._per_page = jsonData[source.perPage].stringValue
        self._total = jsonData[source.totalOrders].intValue
        self._runner_rate = jsonData[source.runnerRate].intValue
        
        
    }
    
    
}



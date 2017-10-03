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
                    print(response.result.error)
                    return
                    
                }
                let json = JSON( value) // SwiftyJSON
                                print("that is  getMenuData getting the data Mate : %@", response.result.value)
                let parm = Constants.API.Parameters()
                
                let data = User_DataModel(json[parm.user])
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
                
                let data = User_DataModel(json[parm.user])
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
    
//    func multiPart1(    imageDict : [String:UIImage],completed : @escaping (User_DataModel?,Bool,String)->()) {
//        let  parameters  : [String:Any] = [
//            "id": "39",
//            "transportation" : "car",
//            "start_time": "today",
//            "work_hours": "more than 4 hours",
//            "morning": "0",
//            "afternoon": "1",
//            "evening": "1",
//            "late_night": "0",
//            
//            ]
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key,value) in imageDict{
//                if let imageData = UIImageJPEGRepresentation(value, 1) {
////                    multipartFormData.append(imageData, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
//                    multipartFormData.append(imageData, withName: key, fileName: "swift_file.jpg", mimeType: "image/jpg")
//                 }
//            }
//            for (key, value) in parameters {
////                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key as String)
//                 multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//        }, to:source.POST_REGISTER_DETAILS, method: .post, headers: source.HEADER)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
////                upload.uploadProgress(closure: { (Progress) in
////                    print("Upload Progress: \(Progress.fractionCompleted)")
////                })
//                
//                upload.responseJSON { response in
//                    //self.delegate?.showSuccessAlert()
//                    print("original URL request\n\(response.request)\n\n")  // original URL request
//                    print("response \n:\(response.response)\n\n") // URL response
//                    print("data :\n\(response.data)\n\n")      // server data
//                    print("result :\n\(response.result)\n\n")    // result of response serialization
//                    //                        self.showSuccesAlert()
//                    //self.removeImage("frame", fileExtension: "txt")
//                    guard  let value = response.result.value else {
//                         return
//                    }
//                    let json = JSON( value) // SwiftyJSON
//                    print("that;s json \(json)")
//                }
//                
//            case .failure(let encodingError):
//                //self.delegate?.showFailAlert()
//                print(encodingError)
//            }
//            
//        }
//    }
//    func postRegisterationDetails( registerParameters : [String:Any], imageDict : [String:Data],completed : @escaping (User_DataModel?,Bool,String)->()) {
//
//        let url = source.POST_REGISTER
//        print("URL: is postRegisterRequest RL : \(url)")
//
//        let parameters : = [
//            "file_name": "swift_file.jpeg"
//        ]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(UIImageJPEGRepresentation(self.photoImageView.image!, 1)!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            for (key, value) in parameters {
//                multipartFormData.append(value, withName: key)
//            }
//        }, to:"http://sample.com/upload_img.php")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    //Print progress
//                })
//
//                upload.responseJSON { response in
//                    //print response.result
//                }
//
//            case .failure(let encodingError):
//                //print encodingError.description
//            }
//        }
//    }

    /*
     {
     
     let url = source.POST_REGISTER
     print("URL: is postRegisterRequest RL : \(url)")
     var imageData: NSMutableData?
     for (key,value ) in imageDict {
     imageData = NSMutableData(data: value);
     
     }
     
     Alamofire.upload(.POST, "http://localhost:8080/rest/service/upload?attachmentName=file.jpg",  imageData)
     .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
     println(totalBytesWritten)
     }
     .responseString { (request, response, JSON, error) in
     println(request)
     println(response)
     println(JSON)
     }
     }
 */
    
    
    
//    func test2() {
//
//        let parameters = [
//            "file_name": "swift_file.jpeg"
//        ]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(UIImageJPEGRepresentation(self.photoImageView.image!, 1)!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to:"http://sample.com/upload_img.php")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    //Print progress
//                })
//
//                upload.responseJSON { response in
//                    //print response.result
//                }
//
//            case .failure(let encodingError):
//                //print encodingError.description
//            }
//        }
//
//    }
//    func test() {
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            multipartFormData.append(imageData, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//            multipartFormData.append(imageData, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
//
//        }, to:"http://server1/upload_img.php")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (Progress) in
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                })
//
//                upload.responseJSON { response in
//                    //self.delegate?.showSuccessAlert()
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    //                        self.showSuccesAlert()
//                    //self.removeImage("frame", fileExtension: "txt")
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//                }
//
//            case .failure(let encodingError):
//                //self.delegate?.showFailAlert()
//                print(encodingError)
//            }
//
//        }
//    }
    
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
 
 */


class OrderDataAndDetails {
    private   let source = Constants.API.Parameters()
    
    //[
    private var _id :Int?
    
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
 
    //]
    
    //[
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
 
        
    }
    
    
}



//
//  M_MenuData.swift
//  Mercato
//
//  Created by Macbook Pro on 8/24/17.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

 
import Foundation
import Alamofire
import SwiftyJSON


//class M_USER_Request {
//
//
//    //(completed : @escaping ([RepoVars]?) ->())
//    private  let source = Constants.API.URLS()
//    private   let parSource = Constants.API.Parameters()
//
//    func getMenuData( completed : @escaping ([GetMenuVars]?,Bool)->()) {
//
//        let url = source.GET_OUR_MENU
//        //        print("URL: is postLoginData RL : \(url)")
//
//        Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
//            //            print(response.result)
//            switch(response.result) {
//            case .success(_):
//                guard response.result.error == nil, let value = response.result.value  else {
//
//                    // got an error in getting the data, need to handle it
//                    //                    print("error fetching data from url")
//                    print(response.result.error)
//                    return
//
//                }
//                let json = JSON( value) // SwiftyJSON
////                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value)
//                let parm = Constants.API.Parameters()
//                let status: Bool  =  json[parm.api_status].intValue == 0 ? false : true
////                let  api_message = json[parm.api_message].stringValue
//                let data = json[parm.data]
//                var menus = [GetMenuVars]()
//                for (_,json ) in data {
//                  menus.append(GetMenuVars(json))
//                }
//
//                //                let data = json["data"]
//
//                //                var profileData =  PostLoginVars(data)
//
//
//                completed( menus, status )
//                break
//
//            case .failure(_) :
//
//                //                if let data = response.data {
//                //                    let json = String(data: data, encoding: String.Encoding.utf8)
//                //                    print("Failure Response: \(json)")
//                //                }
////                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
//
//                completed(nil  , false)
//                break
//            }
//        }
//    }
//
//
//
//    func getProductsData( completed : @escaping ([GetProductsVars]?,Bool)->()) {
//
//        let url = source.GET_PRODUCTS
//        //        print("URL: is postLoginData RL : \(url)")
//
//        Alamofire.request(url , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: source.HEADER).responseJSON { (response:DataResponse<Any>) in
//            //            print(response.result)
//            switch(response.result) {
//            case .success(_):
//                guard response.result.error == nil, let value = response.result.value  else {
//
//                    // got an error in getting the data, need to handle it
//                    //                    print("error fetching data from url")
////                    print(response.result.error)
//                    return
//
//                }
//                let json = JSON( value) // SwiftyJSON
////                print("that is  postUserData_LOGIN getting the data Mate : %@", response.result.value)
//                let parm = Constants.API.Parameters()
//                let status: Bool  =  json[parm.api_status].intValue == 0 ? false : true
//                //                let  api_message = json[parm.api_message].stringValue
//                let data = json[parm.data]
//                var menus = [GetProductsVars]()
//                for (_,json ) in data {
//                    menus.append(GetProductsVars(json))
//                }
//
//                //                let data = json["data"]
//
//                //                var profileData =  PostLoginVars(data)
//
//
//                completed( menus, status )
//                break
//
//            case .failure(_) :
//
//                //                if let data = response.data {
//                //                    let json = String(data: data, encoding: String.Encoding.utf8)
//                //                    print("Failure Response: \(json)")
//                //                }
////                print("that is fail i n getting the Login data Mate : \(response.result.error?.localizedDescription)")
//
//                completed(nil  , false)
//                break
//            }
//        }
//    }
//
//}


//    class GetProductsVars {
//        private   let source = Constants.API.Parameters()
//        private   let imageURL = Constants.API.URLS()
//
//        //[
//        private var _id :Int?
//
//        private var _name  : String?
//        private var _photo : String?
//
//        //]
//
//        //[
//        var name : String {
//            guard let x = _name else { return "" }
//            return x
//        }
//
//
//        var id : Int {
//            guard let x = _id else { return 0 }
//            return x
//        }
//        var photo : String {
//            guard let x = _photo else { return "" }
//            return x
//        }
//
//
//        init(_ jsonData : JSON) {
//            self._name = jsonData[source.name].stringValue
//            self._photo = jsonData[source.photo].stringValue
//            self._id = jsonData[source.id].intValue
//
//
//        }
//
//
//    }






//class GetMenuVars {
//    private   let source = Constants.API.Parameters()
//    private   let imageURL = Constants.API.URLS()
//    
//    //[
//    private var _id :Int?
//    
//    private var _birthday  : String?
//    private var _name  : String?
//    private var _photo : String?
// 
//    //]
//    
//    //[
//      var name : String {
//        guard let x = _name else { return "" }
//        return x
//    }
//   
//    var photo : String {
//        guard let x = _photo else { return "" }
//        return x
//    }
//   
//    var id : Int {
//        guard let x = _id else { return 0 }
//        return x
//    }
//    
//    
//    
//    init(_ jsonData : JSON) {
//        self._name = jsonData[source.name].stringValue
//         self._photo = jsonData[source.photo].stringValue
//         self._id = jsonData[source.id].intValue
//        
//        
//    }
//    
//    
//}


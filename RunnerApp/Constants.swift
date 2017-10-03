//
//  Constants.swift
//  Elmla3eb
//
//  Created by Macbook Pro on 3/12/17.
//  Copyright © 2017 Killvak. All rights reserved.
//

import Foundation
import UIKit





class Constants  {
    
    // #5a1e18   dark red
    // #b42024   light red
    
    
    static let screenSize: CGRect = UIScreen.main.bounds
    
    class API {

        private static let main_url = "http://192.168.1.140/breeze/api/v1/"
        private static let runner_path  = "runner/"

        
        class URLS {
            //            let API_TOKEN = "?api_token=776645543"
            //            let IMAGES_URL = "https://almala3b.com/"
            //           private  let HEADER_ID  = "X-Authorization-token"
            //           private  let HEADER_Value = "12b20fa6cca0ee113dc92d16f6be3029"
            
            let HEADER = ["Authorization" : "Basic YkBuLmNvbToxMjM0NTY="]
            let SINGLE_HEADER = ["Content-Type":"application/json"]
            let IMAGE_URL = "http://mercatocoffee.com/"

            //ARTICLES
            //            let POST_ARTICLES_DATA = API.main_url + "articles"
            //            let GET_ARTICLES_ALL = API.main_url + "articles"
            //            let GET_ARTICLES_DATA_BY_ID = API.main_url + "articles/"
            //////////////
            //User
            let POST_Registeration = API.main_url + runner_path + "register"
            let POST_Email_Existance = API.main_url + runner_path + "email"
            let POST_REGISTER_DETAILS = API.main_url + "runner/update_details"
            
            let GET_RUNNER_PROFILE_BY_ID = API.main_url + "runner/"//ADD THE ID
            let POST_GO_OFFLINE = API.main_url + "offline"
            let POST_GO_ONLINE = API.main_url + "online"
            let POST_RESET_PASSWORD = API.main_url + "/runner/resetPassword"
            let POST_LOGIN = API.main_url + "user/login"
            let GET_RUNNER_RATE_BY_ID = API.main_url + "rate/runner/"//ADD THE ID

            let POST_ONESIGNAL_PLAYID = API.main_url + "user/player_id"
        }
        
        class Parameters {
            let requestHasFailed = "Request has failed,Please check your network connection"
            //DiNames
            let user = "user"
            //Global
            let id = "id"
            let status_code = "status_code"
            let error = "error"
            let status = "status"
            let data = "data"
            //Register
            let name = "name"
            let first_name = "first_name"
            let last_name = "last_name"
            let email = "email"
            let referal_code = "referal_code"
            let refered_by = "refered_by"
            let provider = "provider"
            let message = "message"
            
            //User
            let phone = "phone"
            let points = "points"
            let transportation = "transportation"
            let work_hours = "work_hours"
            let is_admin = "is_admin"
            let morning = "morning"
            let afternoon = "afternoon"
            let evening = "evening"
            let late_night = "late_night"
 
        }
        
    }
    
    
    
    
    
    
    
    
    
}

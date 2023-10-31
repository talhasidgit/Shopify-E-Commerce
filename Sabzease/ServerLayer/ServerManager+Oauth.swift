////
////  ServerManager+Oauth.swift
////  Rang Rasiya
////
////  Created by Zain Ali on 02/08/2018.
////  Copyright © 2018 A2L. All rights reserved.
////
//
//import Foundation
//import OAuthSwift
//
//let CUNSUMERKEY = "03x8prvseaugsrc5qu5m37khjudrk41q"
//let CUNSUMERSECRET = "sqnbsbaf0vk6tubc4jgalb7e34m6nueu"
//let OAUTHTOKEN = "w6ocfm6xg257dk7j6bmv0utxpbelce8e"
//let OAUTHTOKENSECRET = "i1hp000gvvxkhmfa44voqquxjnua2kv6"
//
//extension ServerManager{
//    
//    func getOrders(userEmail:String, completion:@escaping (_ JSON:AnyObject) -> ()){
//
//        // create an instance and retain it
//        let oauthswift = OAuth1Swift(
//            consumerKey:    CUNSUMERKEY,
//            consumerSecret: CUNSUMERSECRET
//        )
//        oauthswift.client.credential.oauthToken = OAUTHTOKEN
//        oauthswift.client.credential.oauthTokenSecret = OAUTHTOKENSECRET
//
//        // do your HTTP request without authorize
//        oauthswift.client.get("https://rangrasiya.com.pk/index.php/rest/V1/orders?searchCriteria[filter_groups][0][filters][0][value]=\(userEmail)&searchCriteria[filter_groups][0][filters][0][field]=customer_email",
//            success: { response in
//                //....
//                print(response)
//                do{
//                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String: Any]
//                    print(json)
//                    if json.keys.contains("exception"){
//                        let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
//                        completion(errorDictionary as AnyObject)
//                    }else if json.keys.contains("errors"){
//                        let message = json["message"] as! String
//                        if let dict = json["errors"]{
//
//                            let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
//                            if errorMsgs == ""{
//                                let errorDictionary = ["status": "error" , "message": message]
//                                completion(errorDictionary as AnyObject)
//                            }else{
//                                let errorDictionary = ["status": "error" , "message": errorMsgs]
//                                completion(errorDictionary as AnyObject)
//                            }
//                        }
//                    }else if json.keys.contains("trace"){
//                        let errorMsgs = json["message"] as! String
//                        let errorDictionary = ["status": "error" , "message": errorMsgs]
//                        completion(errorDictionary as AnyObject)
//                    }else{
//                        completion(json as AnyObject)
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                    print("error")
//                    let errorDictionary = ["status": "error" , "message": error.localizedDescription]
//                    completion(errorDictionary as AnyObject)
////                    let json = String(data: response.data, encoding: .utf8)
////                    print(json ?? "")
////                    completion(json as AnyObject)
//                }
//        },
//            failure: { error in
//                //...
//                print("eroor")
//                print(error.localizedDescription)
//                let errorDictionary = ["status": "error" , "message": error.localizedDescription]
//                completion(errorDictionary as AnyObject)
//        })
//    }
//}

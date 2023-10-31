//
//  ServerManager.swift
//  ThyFiChef
//
//  Created by Sheikh Yousaf on 17/03/2018.
//  Copyright © 2018 oDoCode. All rights reserved.
//

import Foundation
import UIKit

class ServerManager{
    
    static let sharedInstance=ServerManager()
    let BASE_URL = "https://sabzease.myshopify.com/admin/api/2021-04/"  // Live
    let searchProductUrl = "https://sabzease.myshopify.com/search/suggest.json?"
    
    //Username = 5386c7729fd3e6de8ea413761b8a52d3
    //Password = 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
    let basicAuth = "Basic ODY0NmMxODRiYmRhY2NkNDliZTk3ZjlmNDYwYjQwNmU6c2hwcGFfNmE5MDlhMDQyZGQzZTlmMzhjNmYwZDhiMmVkNzZiYjM="
    

    private init(){}
    
    func postRequestToken(url:String,completion:@escaping (_ JSON:AnyObject) -> ()){
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": basicAuth,
            "grant_type": "client_credentials"
            ]
        
        var request:NSMutableURLRequest!
        do {
//            let postData = try JSONSerialization.data(withJSONObject: param, options: [])
            request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
//            request.httpBody = postData
        }
//        catch{//stop activity
//            print("Error")
//        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("eroor")
                print(error?.localizedDescription ?? "")
                let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                completion(errorDictionary as AnyObject)
            }else {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    print(json)
                    if json.keys.contains("exception"){
                        let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
                        completion(errorDictionary as AnyObject)
                    }else if json.keys.contains("errors"){
//                        let message = json["message"] as! String
                        if let dict = json["errors"]{
                            
                            let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
                            if errorMsgs == ""{
                                let errorDictionary = ["status": "error" , "message": "Something Went wrong"]
                                completion(errorDictionary as AnyObject)
                            }else{
                                let errorDictionary = ["status": "error" , "message": errorMsgs]
                                completion(errorDictionary as AnyObject)
                            }
                        }
                    }else if json.keys.contains("error"){
                        let errorMsgs = json["error_description"] as! String
                        let errorDictionary = ["status": "error" , "message": errorMsgs]
                        completion(errorDictionary as AnyObject)
                    }else{
                        completion(json as AnyObject)
                    }
                }
                catch{
                    print(error.localizedDescription)
                    print("error")
                    let errorDictionary = ["status": "error" , "message": error.localizedDescription]
                    completion(errorDictionary as AnyObject)
                    
                    //FOR String Response
//                    let json = String(data: data!, encoding: .utf8)
//                    print(json ?? "")
//                    completion(json as AnyObject)
                }
            }
        })
        dataTask.resume()
    }
    
    func putRequest(param:[String:Any],url:String,completion:@escaping (_ JSON:AnyObject) -> ()){
        
//        let userData = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
//        var token = ""
//        if userData != nil{
//            token = "Bearer " + (userData?.access_token)!
//        }else{
//            token = ""
//        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": basicAuth, //token,
            "grant_type": "client_credentials"
        ]
        
        var request:NSMutableURLRequest!
        do {
            let postData = try JSONSerialization.data(withJSONObject: param, options: [])
            request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
        }
        catch{//stop activity
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("eroor")
                print(error?.localizedDescription ?? "")
                let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                completion(errorDictionary as AnyObject)
            }else {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    print(json)
                    if json.keys.contains("exception"){
                        let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
                        completion(errorDictionary as AnyObject)
                    }else if json.keys.contains("errors"){
//                        let message = json["message"] as! String
                        if let dict = json["errors"]{
                            
                            let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
                            if errorMsgs == ""{
                                let errorDictionary = ["status": "error" , "message": "Something went wrong"]
                                completion(errorDictionary as AnyObject)
                            }else{
                                let errorDictionary = ["status": "error" , "message": errorMsgs]
                                completion(errorDictionary as AnyObject)
                            }
                        }
                    }else if json.keys.contains("trace"){
                        let errorMsgs = json["message"] as! String
                        let errorDictionary = ["status": "error" , "message": errorMsgs]
                        completion(errorDictionary as AnyObject)
                    }else{
                        completion(json as AnyObject)
                    }
                }
                catch{
                    //                    print(error.localizedDescription)
                    //                    print("error")
                    //                    let errorDictionary = ["status": "error" , "message": error.localizedDescription]
                    //                    completion(errorDictionary as AnyObject)
                    let json = String(data: data!, encoding: .utf8)
                    print(json ?? "")
                    completion(json as AnyObject)
                }
            }
        })
        dataTask.resume()
    }
    
    func postRequest(param:[String:Any],url:String,fnToken:String,completion:@escaping (_ JSON:AnyObject, _ fnToke:String) -> ()){
        print(url)
        print(param)
            
            let headers = [
                    "Content-Type": "application/json",
                    "Authorization": basicAuth,
                    //"grant_type": "client_credentials"
                ]
        guard let url = URL(string: url) else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            do {
                let postData = try JSONSerialization.data(withJSONObject: param, options: [])
                
                urlRequest.httpMethod = "POST"
                urlRequest.allHTTPHeaderFields = headers
                urlRequest.httpBody = postData
                print(postData)
            }
            catch{//stop activity
                print(error.localizedDescription)
            }
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
           URLCache.shared.removeAllCachedResponses()
            let dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    
                    print("eroor")
                    print(error?.localizedDescription ?? "")
                    let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                    completion(errorDictionary as AnyObject, "")
                    
                }else {
                    do{
                        var otpToken = ""
                        let json:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                        print(json)
                        if let httpResponse = response as? HTTPURLResponse {
                            if let xDemAuth = httpResponse.allHeaderFields["FN-Token"] as? String {
                                print(xDemAuth)
                                otpToken = xDemAuth
                            }
                        }
                        if json.keys.contains("exception"){
                            let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
                            completion(errorDictionary as AnyObject, "")
                        }else if json.keys.contains("errors"){
    //                        let message = json["message"] as! String
                            if let dict = json["errors"]{
                                
                                let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
                                if errorMsgs == ""{
                                    let errorDictionary = ["status": "error" , "message": "Something Went Wrong"]
                                    completion(errorDictionary as AnyObject, "")
                                }else{
                                    let errorDictionary = ["status": "error" , "message": errorMsgs]
                                    completion(errorDictionary as AnyObject, "")
                                }
                            }
                        }else if json.keys.contains("errorCode"){
                            let errorMsgs = json["message"] as! String
                            let errorDictionary = ["status": "error" , "message": errorMsgs]
                            completion(errorDictionary as AnyObject, "")
                        }else{
                            completion(json as AnyObject, otpToken)
                        }
                    }
                    catch{
                        print(String(describing: error))
                        let errorDictionary = ["status": "error" , "message": "Server Error"]
                        completion(errorDictionary as AnyObject, "")
                    }
                }
            })
            dataTask.resume()
        }

    
    func postArrayRequest(param:[String:Any],url:String,completion:@escaping (_ JSON:AnyObject) -> ()){
        
//        let userData = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
//        var token = ""
//        if userData != nil{
//            token = "Bearer " + (userData?.access_token)!
//        }else{
//            token = ""
//        }
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": basicAuth,//token,
            "grant_type": "client_credentials"
            ]
        
        var request:NSMutableURLRequest!
        do {
            let postData = try JSONSerialization.data(withJSONObject: param, options: [])
            request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
        }
        catch{//stop activity
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print("eroor")
                print(error?.localizedDescription ?? "")
                let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                completion(errorDictionary as AnyObject)
            }else {
                do{
                    if try! JSONSerialization.jsonObject(with: data!, options: []) is Array<Any>{
                        
                        let json1 = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                        var json:[String:Any]?
                        for i in 0..<json1.count{
                            
                            let j = json1[i]
                            if j["available"] as! Bool{
                                json = j
                                break
                            }else{
                                completion(j as AnyObject)
                            }
                        }
                        print(json ?? "")
                        if (json?.keys.contains("exception"))!{
                            let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
                            completion(errorDictionary as AnyObject)
                        }else if (json?.keys.contains("errors"))!{
//                            let message = json!["message"] as! String
                            if let dict = json!["errors"]{
                                
                                let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
                                if errorMsgs == ""{
                                    let errorDictionary = ["status": "error" , "message": "Something went wrong"]
                                    completion(errorDictionary as AnyObject)
                                }else{
                                    let errorDictionary = ["status": "error" , "message": errorMsgs]
                                    completion(errorDictionary as AnyObject)
                                }
                            }
                        }else if (json?.keys.contains("trace"))!{
                            let errorMsgs = json!["message"] as! String
                            let errorDictionary = ["status": "error" , "message": errorMsgs]
                            completion(errorDictionary as AnyObject)
                        }else{
                            completion(json as AnyObject)
                        }
                    }else{
                        let json1 = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        let errorDictionary = ["status": "error" , "message": json1["message"]]
                        completion(errorDictionary as AnyObject)
                    }
                    
                }
                catch{
                    print(error.localizedDescription)
                    print("error")
                    let errorDictionary = ["status": "error" , "message": "Server Error"]
                    completion(errorDictionary as AnyObject)
                }
            }
        })
        dataTask.resume()
    }
    
    func getArrayRequest(url:String,completion:@escaping (_ JSON:AnyObject) -> ()){
        
//        let userData = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
//        var token = ""
//        if userData != nil{
//            token = "Bearer " + (userData?.access_token)!
//        }else{
//            token = ""
//        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": basicAuth,//token,
            "grant_type": "client_credentials"
            ]
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.allHTTPHeaderFields = headers
        
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error?.localizedDescription ?? "errorsin")
                let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                completion(errorDictionary as AnyObject)
                return
            }
            do {
                
                if try! JSONSerialization.jsonObject(with: data!, options: []) is Array<Any>{
                    let json1 = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                    if json1.count > 0{
                        completion(json1 as AnyObject)
                    }else{
                        let errorDictionary = ["status": "error" , "message": "You have an empty wishlist"]
                        completion(errorDictionary as AnyObject)
                    }
                }else{
                    let json1 = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        let errorDictionary = ["status": "error" , "message": json1["message"]]
                        completion(errorDictionary as AnyObject)
                }
                
            }//do ends
            catch let jsonError {
                print("erroooorr")
                print(jsonError.localizedDescription)
                let errorDictionary = ["status": "error" , "message": "Server Error"]
                completion(errorDictionary as AnyObject)
                
            }//catch ends
        }
        task.resume()
    }
    
    func getRequest(url:String,completion:@escaping (_ JSON:AnyObject) -> ()){
        
//        let userData = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
//        var token = ""
//        if userData != nil{
//            token = "Bearer " + (userData?.access_token)!
//        }else{
//            token = ""
//        }
        
        guard let myUrl = URL(string:url) else {
            // incorporate error
            return
        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": basicAuth, //token,
            //"grant_type": "client_credentials"
        ]
        
        var urlRequest = URLRequest(url: myUrl)
        
        urlRequest.allHTTPHeaderFields = headers
        
        // urlRequest.addValue("token \(ConfirmationViewController.userToken.value(forKey: "Token") as! String)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error?.localizedDescription ?? "errorsin")
                let errorDictionary = ["status": "error" , "message": error?.localizedDescription]
                completion(errorDictionary as AnyObject)
                return
            }
            do {
                
                print("inthedo")
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                print(json)
                if json.keys.contains("exception")
                {
                    let errorDictionary = ["status": "error" , "message": "Server Error!!!"]
                    completion(errorDictionary as AnyObject)
                }else if json.keys.contains("errors"){
                    
//                    let message = json["message"] as! String
                    if let dict = json["errors"]{
                        
                        let errorMsgs =  Utilities.sharedInstance.getProperValidationMsg(dict as? [String: Any])!
                        if errorMsgs == ""{
                            let errorDictionary = ["status": "error" , "message": "Something went wrong"]
                            completion(errorDictionary as AnyObject)
                        }else{
                            let errorDictionary = ["status": "error" , "message": errorMsgs]
                            completion(errorDictionary as AnyObject)
                        }
                    }
                }else if json.keys.contains("trace"){
                    let errorMsgs = json["message"] as! String
                    let errorDictionary = ["status": "error" , "message": errorMsgs]
                    completion(errorDictionary as AnyObject)
                }else{
                    completion(json as AnyObject)
                }
                
            }//do ends
            catch let jsonError {
                print("erroooorr")
                print(jsonError.localizedDescription)
                let errorDictionary = ["status": "error" , "message": "Server Error"]
                completion(errorDictionary as AnyObject)
                
            }//catch ends
        }
        task.resume()
    }
  
}

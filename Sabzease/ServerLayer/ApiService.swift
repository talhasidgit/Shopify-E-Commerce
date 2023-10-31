//
//  ApiService.swift
//  Demo
//
//  Created by MAC on 08/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import Alamofire

class ApiService
{
    static let sharedInstance=ApiService()
    static let BASE_URL = "http://203.215.173.200:8080/hunarkaarDashboard/"  // Live
    
    private init(){}
    
    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        
        var billingAddress = ""
        var lineItems = ""
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params["billing_address"]!,
            options: []) {
            billingAddress = String(data: theJSONData,
                           encoding: .ascii)!
            print("JSON string = \(billingAddress)")
        }
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params["line_items"]!,
            options: []) {
            lineItems = String(data: theJSONData,
                                    encoding: .ascii)!
            print("JSON string = \(lineItems)")
        }
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)

        do {
            let postData = try JSONSerialization.data(withJSONObject: params, options: [])
            print(postData)
            Alamofire.upload(multipartFormData: { multipart in
                multipart.append("\(params["email"] ?? "")".data(using: .utf8)!, withName :"email" )
                multipart.append("\(params["user_id"] ?? "")".data(using: .utf8)!, withName: "user_id" )
                multipart.append("\(params["device"] ?? "")".data(using: .utf8)!, withName: "device" )
                multipart.append(billingAddress.data(using: .utf8)!, withName: "billing_address" )
                multipart.append(lineItems.data(using: .utf8)!, withName: "line_items" )
            }, to: url, method: .post, headers: nil) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.response { answer in
                        print("statusCode: \(String(describing: answer.response?.statusCode))")

                    }
                    upload.responseJSON { response in
                        
                        result.message = "Success"
                        result.data = response.data
                        finish(result)
                        
                    }
                    upload.uploadProgress { progress in
                        //call progress callback here if you need it
                    }
                case .failure(let encodingError):
                    print("multipart upload encodingError: \(encodingError)")
                }
            }
        }
        catch{//stop activity
        }
    }
}

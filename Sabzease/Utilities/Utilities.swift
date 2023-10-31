//
//  Utilities.swift
//  YoFit
//
//  Created by Ali Asad on 28/03/2018.
//  Copyright © 2018 Ali Asad. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandlerForDialog = (_ success: ErrorDialogAction) -> ()

protocol DialogProtocol {
    func dialogResponse(action:ErrorDialogAction)
}

extension DialogProtocol{
    func dialogResponse(action:ErrorDialogAction){
        
    }
}

enum ErrorDialogAction {
    case Yes
    case No
}

protocol ErrorDialogProtocol {
    func response(action:ErrorDialogAction)
}

public class Utilities{
    
    static var sharedInstance = Utilities()
    
    func showAlert(msg: String , title:String) -> Void {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func getProperValidationMsg(_ message: Any?) -> String? {
        let alerts : NSMutableArray = []
        if (message is String) {
            if let aMessage = message {
                alerts.add(aMessage)
            }
        } else if (message != nil) {
            let dict = message as! [String: Any]
            for key: String? in (dict.keys) {
                var message: String? = nil
                if key == nil{
                    break
                }else{
                    if let aKey = dict[key!] {
                        message = "\(aKey)"
                    }
                    message = message?.replacingOccurrences(of: "(", with: "")
                    message = message?.replacingOccurrences(of: ")", with: "")
                    alerts.add(message ?? "")
                }
            }
        }
        let errorMessages = alerts.copy() as! NSArray
        return errorMessages.componentsJoined(by: "")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getTokenSession(forKey: String) -> UserToken? {
        
        let decoder = JSONDecoder()
        if let userInfo = UserDefaults.standard.data(forKey: forKey),
            let userInformation = try? decoder.decode(UserToken.self, from: userInfo) {
            return userInformation
        }
        return nil
    }
    
    func getUserData(forKey: String) -> UserModel? {
        
        let decoder = JSONDecoder()
        if let userInfo = UserDefaults.standard.data(forKey: forKey),
            let userInformation = try? decoder.decode(UserModel.self, from: userInfo) {
            return userInformation
        }
        return nil
    }
    
    func removeSession(forKey: String){
        
        UserDefaults.standard.set(nil, forKey: forKey)
    }
    
    func showStandardDialog(alertTitle: String, alertMessage: String, okButtonTitle: String, cancelButtonTitle: String, sender: UIViewController, completionHandler:  CompletionHandlerForDialog?) {

        // Prepare the popup
        let title = alertTitle
        let message = alertMessage

        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                gestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }

        var buttons = [PopupDialogButton]()
        if cancelButtonTitle != "" {
            let buttonOne = CancelButton(title: cancelButtonTitle) {

                if completionHandler != nil{
                    completionHandler!(.No)
                }
            }
            buttons.append(buttonOne)
        }

        if okButtonTitle != "" {
            let buttonOne = DefaultButton(title: okButtonTitle) {
                if completionHandler != nil{
                    completionHandler!(.Yes)
                }
            }
            buttons.append(buttonOne)
        }
        // Add buttons to dialog
        popup.addButtons(buttons)

        // Present dialog
        sender.present(popup, animated: true, completion: nil)
    }
    
    
}

//
//  ChangePassVC.swift
//  ezfresh.pk
//
//  Created by MAC on 08/10/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import CDAlertView
import NVActivityIndicatorView

@available(iOS 13.0, *)
class ChangePassVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var txtCNP: UITextField!
    @IBOutlet weak var txtNP: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    var objProfile : ProfileVC?
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    
    @IBAction func actSkip(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actReset(_ sender: UIButton) {
        
        if checkFiledEmpty(){
            
            if txtCP.text == userInfo?.password{
                if txtNP.text == txtCNP.text{
                    resetPassAPI()
                }else{
                    DispatchQueue.main.async {
                        self.view.makeToast("Password Doesn't Match")
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.view.makeToast("Wrong Passwrod. Try Again!")
                }
            }
        }
    }
    
    //MARK: UItextField Embosed Image Properties
    let iconButton = UIButton()
    var isShow = true
    let iconButtonNP = UIButton()
    var isShowNP = true
    let iconButtonCNP = UIButton()
    var isShowCNP = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reset Password"
        self.txtCNP.delegate = self
        self.txtNP.delegate = self
        setTheme()
    }
    
    func setTheme(){
        
        DispatchQueue.main.async {
            
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            self.viewBG.dropShadow()
            
            self.txtCP.addPadding()
            self.txtCP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            self.txtCP.attributedPlaceholder = NSAttributedString(string: "Current Password",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtNP.addPadding()
            self.txtNP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonNP)
            self.txtNP.attributedPlaceholder = NSAttributedString(string: "New Password (min 5 characters)",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtCNP.addPadding()
            self.txtCNP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCNP)
            self.txtCNP.attributedPlaceholder = NSAttributedString(string: "Confirm New Password",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.btnReset.layer.cornerRadius = 10
            self.btnReset.clipsToBounds = true
            
        }
        iconButton.addTarget(self, action: #selector(self.showHidePassButton), for: .touchUpInside)
        iconButtonNP.addTarget(self, action: #selector(self.showHidePassButtonNP), for: .touchUpInside)
        iconButtonCNP.addTarget(self, action: #selector(self.showHidePassButtonCNP), for: .touchUpInside)
    }
    
    @objc func showHidePassButton(){
        
        if isShow{
            self.txtCP.withImage(direction: .Right, image: UIImage(named: "ic_Hide")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            isShow = false
            self.txtCP.isSecureTextEntry = false
        }else{
            self.txtCP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            isShow = true
            self.txtCP.isSecureTextEntry = true
        }
    }
    
    @objc func showHidePassButtonNP(){
        
        if isShowNP{
            self.txtNP.withImage(direction: .Right, image: UIImage(named: "ic_Hide")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonNP)
            isShowNP = false
            self.txtNP.isSecureTextEntry = false
        }else{
            self.txtNP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonNP)
            isShowNP = true
            self.txtNP.isSecureTextEntry = true
        }
    }
    
    @objc func showHidePassButtonCNP(){
        
        if isShowCNP{
            self.txtCNP.withImage(direction: .Right, image: UIImage(named: "ic_Hide")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCNP)
            isShowCNP = false
            self.txtCNP.isSecureTextEntry = false
        }else{
            self.txtCNP.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCNP)
            isShowCNP = true
            self.txtCNP.isSecureTextEntry = true
        }
    }
    
    //MARK: VALIDATIONS
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(txtCP.text==""){
            
            txtCP.attributedPlaceholder = NSAttributedString(string: "Provied Current Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        
        if(txtNP.text==""){
            txtNP.attributedPlaceholder = NSAttributedString(string: "Provide New Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtCNP.text==""){
            txtCNP.attributedPlaceholder = NSAttributedString(string: "Provide New Password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        return valid
    }
    
    func resetPassAPI(){
        
        let prm = ["id":(userInfo?.userID!)! as CLong,
                   "password":self.txtNP.text! as String,
                   "password_confirmation":txtCNP.text! as String] as [String:AnyObject]
        print(prm)
        let param = ["customer":prm]
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.putRequest(param: param,url: ServerManager.sharedInstance.BASE_URL + "customers/\((userInfo?.userID!)!).json", completion: {js in
            print(js)
            self.getDataInfo(json: js)
        })
    }
    
    fileprivate func getDataInfo(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if json.keys.contains("status"){
                let pass = json["message"] as! String
                let errorMessage = pass
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.view.makeToast(errorMessage)
                }
            }else{
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.userInfo?.password = self.txtNP.text
                    self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
                    self.dismiss(animated: true) {
                        if self.objProfile != nil{
                            self.objProfile!.view.makeToast("Password Changed Successfully!")
                        }
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
                self.activityView.stopAnimating()
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
        }
    }
    
    func showErrorMessage(message:String){
        
        let alert = CDAlertView(title: "", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
        }
    }
    
    //MARK: UITextField Delegate
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if textField.isEqual(txtNP) || textField.isEqual(txtCNP){
//            let maxLength = 5
//            let currentString: NSString = (textField.text ?? "") as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length >= maxLength
//        }else{
//            return true
//        }
//    }
}

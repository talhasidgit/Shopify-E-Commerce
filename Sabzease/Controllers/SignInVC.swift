//
//  SignInVC.swift
//  ezfresh.pk
//
//  Created by MAC on 21/08/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import CDAlertView
import MobileBuySDK
import NVActivityIndicatorView

@available(iOS 13.0, *)
class SignInVC: UIViewController {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnFP: UIButton!
    var objMenu: SideMenuVC?
    var objAddress: AddressVC?
    
    //MARK: UItextField Embosed Image Properties
    let iconButton = UIButton()
    var isShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func actSkip(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Custom Methods
    
    func setTheme(){
        
        DispatchQueue.main.async {
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            
            self.txtEmail.addPadding()
            self.txtEmail.layer.cornerRadius = 10
            self.txtEmail.clipsToBounds = true
            self.txtEmail.layer.borderWidth = 2
            self.txtEmail.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtPass.addPadding()
            self.txtPass.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            self.txtPass.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.btnLogin.layer.cornerRadius = 10
            self.btnLogin.clipsToBounds = true
            
            self.btnSignUp.layer.cornerRadius = 10
            self.btnSignUp.clipsToBounds = true
            self.btnSignUp.layer.borderWidth = 2
            self.btnSignUp.layer.borderColor = AppTheme.sharedInstance.Orange.cgColor
            
            self.viewBG.dropShadow()
        }
        iconButton.addTarget(self, action: #selector(self.showHidePassButton), for: .touchUpInside)
    }
    
    @objc func showHidePassButton(){
        
        if isShow{
            self.txtPass.withImage(direction: .Right, image: UIImage(named: "ic_Hide")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            isShow = false
            self.txtPass.isSecureTextEntry = false
        }else{
            self.txtPass.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            isShow = true
            self.txtPass.isSecureTextEntry = true
        }
    }
    
    //MARK: VALIDATIONS
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(txtEmail.text==""){
            
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Provied email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }else{
            if !isValidEmail(testStr: txtEmail.text!){
                txtEmail.text=""
                txtEmail.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        if(txtPass.text==""){
            txtPass.attributedPlaceholder = NSAttributedString(string: "Provide password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        return valid
    }
    
    //checkFiledFills method ends
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func btnActns(_ sender: UIButton) {
        
        if sender.isEqual(btnLogin){
            
            if checkFiledEmpty(){
                
                loginUser()
            }
        }else if sender.isEqual(btnSignUp){
            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUp
            cv.modalTransitionStyle = .crossDissolve
            cv.objMenu = self.objMenu
            cv.objAddress = self.objAddress
            if self.objAddress != nil{
                self.dismiss(animated: false) {
                    self.objAddress?.present(cv, animated: true, completion: nil)
                }
            }
            if self.objMenu != nil{
                self.dismiss(animated: false) {
                    self.objMenu?.present(cv, animated: true, completion: nil)
                }
            }
            //            self.navigationController?.pushViewController(cv, animated: true)
            
        }else if sender.isEqual(btnFP){
            
            let client = Graph.Client(
                shopDomain: "sabzease.myshopify.com",//graphql.myshopify.com
                apiKey:     "263f274f4f230932f3010fcfcf10b898"//8e2fef6daed4b93cf4e731f580799dd1
            )
            
            let alert = CDAlertView(title: "Registered Email", message: "Please enter valid email registered with ezfresh.pk", type: .warning)
            let action = CDAlertViewAction(title: "Proceed")
            let cancelBtn = CDAlertViewAction(title: "Dismiss") { (action) -> Bool in
                self.dissmissAction()
            }
            alert.isTextFieldHidden = false
            alert.add(action: action)
            alert.add(action: cancelBtn)
            alert.hideAnimations = { (center, transform, alpha) in
                transform = .identity
                alpha = 0
            }
            
            alert.show() { (alert) in
                if self.isDissmiss{
                    self.isDissmiss = false
                    print("Dismissed")
                }else{
                    self.activityView.startAnimating()
                    let mutation = Storefront.buildMutation { $0
                        .customerRecover(email: alert.textFieldText ?? "") { $0
                            .customerUserErrors() { $0
                                .field()
                                .message()
                            }
                        }
                    }
                    
                    let task = client.mutateGraphWith(mutation) { result, error in
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                        }
                        if error == nil{
                            if (result?.customerRecover?.customerUserErrors.count)! > 0{
                                let message = result?.customerRecover?.customerUserErrors[0].message ?? "Something went wrong"
                                self.showErrorMessage(message: message)
                            }else{
                                self.showErrorMessage(message: "An email with reset password link has been sent to your email address")
                            }
                        }else{
                            let message = error.debugDescription
                            self.showErrorMessage(message: message)
                        }
                    }
                    task.resume()
                }
            }
        }
    }
    
    var isDissmiss = false
    func dissmissAction() -> Bool{
        isDissmiss = true
        return true
    }
    
    func loginUser(){
        
        //        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        let client = Graph.Client(
            shopDomain: "sabzease.myshopify.com",//graphql.myshopify.com
            apiKey:     "263f274f4f230932f3010fcfcf10b898"//8e2fef6daed4b93cf4e731f580799dd1
        )
        print(client)
        
        let input = Storefront.CustomerAccessTokenCreateInput.create(email: txtEmail.text!, password: txtPass.text!)
        
        let mutation = Storefront.buildMutation { $0
            .customerAccessTokenCreate(input: input) { $0
                .customerAccessToken { $0
                    .accessToken()
                    .expiresAt()
                }
                .customerUserErrors{ $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
            if error == nil{
                
                if result?.customerAccessTokenCreate?.customerUserErrors == nil || result?.customerAccessTokenCreate?.customerUserErrors.count == 0{
                    
                    let accessToken = result?.customerAccessTokenCreate?.customerAccessToken?.accessToken
                    print(accessToken ?? "Token is nil")
                    guard let token = accessToken else{
                        print("Token is ampty")
                        return
                    }
                    print(token)
                    var userSession = UserToken()
                    userSession.access_token = token
                    userSession.saveCurrentSession(forKey: USER_TOKEN_KEY)
                    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
                    userInfo?.email = self.txtEmail.text!
                    userInfo?.password = self.txtPass.text!
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    
                    DispatchQueue.main.async {
                        //GIFHUD.shared.dismiss()
                        self.activityView.stopAnimating()
                        self.getUserData()
                    }
                }else{
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    if let error = result?.customerAccessTokenCreate?.customerUserErrors[0].message{
                        print(error)
                        self.showErrorMessage(message: error)
                        //                    Utilities.sharedInstance.showStandardDialog(alertTitle: "Error", alertMessage: error as String, okButtonTitle: "Ok", cancelButtonTitle: "", sender: self, completionHandler: nil)
                    }else{
                        print("Error is nil")
                    }
                }
            }else{
                if let error = error, case .invalidQuery(let reasons) = error {
                    reasons.forEach {
                        self.showErrorMessage(message: "Error on \(String(describing: $0.line)):\(String(describing: $0.column)) - \($0.message)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func showErrorMessage(message:String) {
        
        let alert = CDAlertView(title: "Customer Login", message: message, type: .warning)
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
    
    func getUserData(){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=email:\(self.txtEmail.text!)", completion: {js in
            print(js)
            self.getDataInfo(json: js)
        })
    }
    
    fileprivate func getDataInfo(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let customers = json["customers"] as? Array<Any> {
                if customers.count > 0{
                    let customerObject = customers[0] as! [String : Any]
                    print(customerObject)
                    userInfo?.userID = (customerObject["id"] as? CLong)
                    userInfo?.name = (customerObject["first_name"] as? String)
                    userInfo?.email = (customerObject["email"] as? String)
                    userInfo?.phoneNumber = (customerObject["phone"] as? String)
                    userInfo?.state = (customerObject["state"] as? String ?? "")
                    DispatchQueue.main.async {
                        self.userInfo?.password = self.txtPass.text
                    }
                    let address = customerObject["default_address"] as? [String : Any]
                    userInfo?.billingAddress?.last_name = address?["last_name"] as? String
                    userInfo?.billingAddress?.address1 = address?["address1"] as? String
                    userInfo?.billingAddress?.addressId = address?["id"] as? Int
                    userInfo?.billingAddress?.city = address?["city"] as? String
                    userInfo?.billingAddress?.zip = address?["zip"] as? String
                    userInfo?.billingAddress?.country = address?["country"] as? String
                    userInfo?.billingAddress?.province = address?["province"] as? String
                    userInfo?.billingAddress?.isDefault = address?["default"] as? Bool
                    
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    DispatchQueue.main.async {
                        //                GIFHUD.shared.dismiss()
                        self.activityView.stopAnimating()
                        self.dismiss(animated: true) {
                            if self.objMenu != nil{
                                self.objMenu?.dismiss(animated: true, completion: nil)
                            }
                            if self.objAddress != nil{
                                self.objAddress?.dismiss(animated: true, completion: {
                                    
                                    self.objAddress?.userToken = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
                                    
                                })
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Server is updating user! Please wait!")
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
}

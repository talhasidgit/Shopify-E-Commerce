//
//  SignUp.swift
//  ezfresh.pk
//
//  Created by MAC on 24/08/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import CDAlertView
import MobileBuySDK
import PhoneNumberKit
import NVActivityIndicatorView

@available(iOS 13.0, *)
class SignUp: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var Height: NSLayoutConstraint!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: PhoneNumberTextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtCPass: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnSingIn: UIButton!
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var userPhone = ""
    var objMenu: SideMenuVC?
    var objAddress: AddressVC?
    
    //MARK: UItextField Embosed Image Properties
    let iconButton = UIButton()
    let iconButtonCP = UIButton()
    var isShowCP = true
    var isShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTheme()
        if (objAddress != nil){
            setData()
        }
        self.txtPhone.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func actSkip(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setData(){
        
        self.txtName.text = (userInfo?.billingAddress?.first_name)! + " " + (userInfo?.billingAddress?.last_name)!
        self.txtEmail.text = userInfo?.billingAddress?.email
        self.txtPhone.text = userInfo?.billingAddress?.phone
        
        self.txtName.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.txtPhone.isUserInteractionEnabled = false
    }
    
    //MARK: Custom Methods
    
    func setTheme(){
        
        DispatchQueue.main.async {
            
            if UIDevice().type == .iPhone8{
                self.topSpace.constant = -80
            }
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            
            self.txtName.addPadding()
            self.txtName.layer.cornerRadius = 10
            self.txtName.clipsToBounds = true
            self.txtName.layer.borderWidth = 2
            self.txtName.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtName.attributedPlaceholder = NSAttributedString(string: "Name*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtEmail.addPadding()
            self.txtEmail.layer.cornerRadius = 10
            self.txtEmail.clipsToBounds = true
            self.txtEmail.layer.borderWidth = 2
            self.txtEmail.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtPhone.addPadding()
            self.txtPhone.withFlag = true
            self.txtPhone.withPrefix = true
            self.txtPhone.withExamplePlaceholder = true
            self.txtPhone.layer.cornerRadius = 10
            self.txtPhone.clipsToBounds = true
            self.txtPhone.layer.borderWidth = 2
            self.txtPhone.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            //            self.txtPhone.attributedPlaceholder = NSAttributedString(string: "+92 301 3243432",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtPass.addPadding()
            self.txtPass.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButton)
            self.txtPass.attributedPlaceholder = NSAttributedString(string: "Password*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtCPass.addPadding()
            self.txtCPass.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCP)
            self.txtCPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.btnCreateAccount.layer.cornerRadius = 10
            self.btnCreateAccount.clipsToBounds = true
            
            self.btnSingIn.layer.cornerRadius = 10
            self.btnSingIn.clipsToBounds = true
            self.btnSingIn.layer.borderWidth = 2
            self.btnSingIn.layer.borderColor = AppTheme.sharedInstance.Orange.cgColor
            
            self.viewBG.dropShadow()
        }
        iconButton.addTarget(self, action: #selector(self.showHidePassButton), for: .touchUpInside)
        iconButtonCP.addTarget(self, action: #selector(self.showHideCPassButton), for: .touchUpInside)
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
    
    @objc func showHideCPassButton(){
        
        if isShowCP{
            self.txtCPass.withImage(direction: .Right, image: UIImage(named: "ic_Hide")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCP)
            isShowCP = false
            self.txtCPass.isSecureTextEntry = false
        }else{
            self.txtCPass.withImage(direction: .Right, image: UIImage(named: "ic_Show")!, colorSeparator: AppTheme.sharedInstance.Light_Green, colorBorder: AppTheme.sharedInstance.Light_Green,iconBtn: self.iconButtonCP)
            isShowCP = true
            self.txtCPass.isSecureTextEntry = true
        }
    }
    
    //MARK: VALIDATIONS
    
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(txtName.text==""){
            
            txtName.attributedPlaceholder = NSAttributedString(string: "Provide name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
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
        if(txtCPass.text==""){
            txtCPass.attributedPlaceholder = NSAttributedString(string: "Provide confirm password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
            
        }
        if(txtPass.text==""){
            txtPass.attributedPlaceholder = NSAttributedString(string: "Provide password",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        if(txtPhone.text==""){
            txtPhone.attributedPlaceholder = NSAttributedString(string: "Provide phone",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{
            do {
                let phoneNumberKit = PhoneNumberKit()
                let phoneNumber = try phoneNumberKit.parse(txtPhone.text!, withRegion: "PK", ignoreType: true)//try phoneNumberKit.parse(txtPhone.text!)
                print(phoneNumberKit.format(phoneNumber, toType: .e164))
                userPhone = phoneNumberKit.format(phoneNumber, toType: .e164)
            }
            catch {
                print("Invalid Phone Number")
                txtPhone.text = ""
                txtPhone.attributedPlaceholder = NSAttributedString(string: "Invalid Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
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
        
        if sender.isEqual(btnCreateAccount){
            
            if checkFiledEmpty(){
                if txtPass.text == txtCPass.text{
                    createUser()
                }else{
                    self.view.makeToast("Password & Confirm Password does not match! Try again")
                }
            }
            
        }else if sender.isEqual(btnSingIn){
//            self.navigationController?.popViewController(animated: true)
            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
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
        }
    }
    
    func createUser(){
        
//        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
//        GIFHUD.shared.show()
        activityView.startAnimating()
        let client = Graph.Client(
            shopDomain: "sabzease.myshopify.com",//graphql.myshopify.com
            apiKey:     "263f274f4f230932f3010fcfcf10b898"//8e2fef6daed4b93cf4e731f580799dd1
        )
        print(client)
        
        let input = Storefront.CustomerCreateInput.create(email: txtEmail.text!, password: txtPass.text!, firstName: Input<String>.value(txtName.text!), phone: Input<String>.value(userPhone), acceptsMarketing: Input<Bool>.value(true))
        
        let mutation = Storefront.buildMutation { $0
            .customerCreate(input: input) { $0
                .customer { $0
                    .id()
                    .email()
                    .firstName()
                    .lastName()
            }
            .customerUserErrors{ $0
            .field()
            .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
//            GIFHUD.shared.dismiss()
            self.activityView.stopAnimating()
            if (error == nil) {
                if result?.customerCreate?.customerUserErrors == nil || result?.customerCreate?.customerUserErrors.count == 0{
                    let checkoutID = (result?.customerCreate?.customer?.id).map { $0.rawValue }
                    print(checkoutID ?? "ID is nil")
                    self.showSuccessMessage()
                    
                }else{
                    
                    if let error = result?.customerCreate?.customerUserErrors[0].message{
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
//                        GIFHUD.shared.dismiss()
                        self.activityView.stopAnimating()
//                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeOldVC") as! HomeOldVC
                        //                    cv.modalTransitionStyle = .crossDissolve
//                        self.navigationController?.pushViewController(cv, animated: true)
                        self.dismiss(animated: true, completion: {
                            if self.objMenu != nil{
                                self.objMenu?.dismiss(animated: true, completion: nil)
                            }
                            if self.objAddress != nil{
                                self.objAddress?.dismiss(animated: true, completion: {
                                    self.objAddress!.userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
                                    self.objAddress?.userEmail = self.txtEmail.text!
                                    self.objAddress?.view.makeToast("User Created Successfully!")
                                    self.objAddress?.isUpdating = true
                                })
                            }
                        })
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
    
    func showErrorMessage(message:String){
        
        let alert = CDAlertView(title: "Customer SignUp", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            if message == "We have sent an email to \(self.txtEmail.text!), please click the link included to verify your email address."{
//                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showSuccessMessage(){
        
        let alert = CDAlertView(title: "Customer SignUp", message: "User created successfully!", type: .success)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            self.loginUser()
        }
    }
    
    //MARK: UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(txtPhone){
            let maxLength = 15
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
}

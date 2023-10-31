//
//  AddressVC.swift
//  Demo
//
//  Created by MAC on 06/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit
import CDAlertView
import MobileBuySDK
import CoreLocation
import PhoneNumberKit
import NVActivityIndicatorView
import iOSDropDown

@available(iOS 13.0, *)
class AddressVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtMobile: PhoneNumberTextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tvAddress:
        UITextView!
    @IBOutlet weak var txtAddress: DropDown!
    var selectedVariant:Int = 0
    var objProduct : Storefront.Product!
    var userAddress : Storefront.MailingAddress!
    var objCheckout : Storefront.Checkout!
    var originalPrice = ""
    var quantity = ""
    var userPhone = ""
    var userEmail = ""
    var isUpdating: Bool = false
    var isUpdated: Bool = false
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var userId : String!
    var locationManager = CLLocationManager()
    var selectedAddress = 0
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actSave(_ sender: UIButton) {
        
        if checkFiledEmpty(){
            hideKeyboard()
            if !isUpdating{
                if userToken == nil{
                    userEmail = self.txtEmail.text!
                    self.getUserData(query: "phone:\(userPhone.components(separatedBy: "+")[1])")
                }else{
                    updateUserData()
                }
            }else{
                self.getUserData(query: "email:\(userEmail)")
            }
        }
    }
    
    
    func updateUserData(){
        
        userInfo?.billingAddress?.last_name = self.txtLName.text
        userInfo?.billingAddress?.first_name = self.txtFName.text
        userInfo?.billingAddress?.email = self.txtEmail.text
        userInfo?.billingAddress?.phone = self.txtMobile.text
        if selectedAddress == 0 {
            userInfo?.billingAddress?.address1 = self.tvAddress.text
        }
        else {
            userInfo?.billingAddress?.address2 = self.tvAddress.text
        }
       
        userInfo?.billingAddress?.city = self.txtCity.text
        userInfo?.billingAddress?.country = self.txtCountry.text
        userInfo?.billingAddress?.province = self.txtProvince.text
        userInfo?.billingAddress?.zip = self.txtPostalCode.text
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        
        if userInfo?.state == "" || userInfo?.state == "disabled" || userInfo?.state == "declined"{
            userInfo?.name = self.txtFName.text
            userInfo?.email = self.txtEmail.text
            self.showLoginMessage(title: "Alert!", message: "Do you want to become a register ezfresh.pk user ?")
            
        }else if userInfo?.state == "invited"{
         
            self.showErrorMessage(message: "We have sent an email to you, please click the link included to verify your email address.")
            
        }else if userInfo?.state == "enabled" && userToken == nil{
            
            self.showLoginMessage(title: "Alert!", message: "Do you want to Login ?")
            
        }else{
            DispatchQueue.main.async {
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
                cv.selectedAddress = self.selectedAddress
                //            cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
            }
        }
    }
    
    func showLoginMessage(title: String, message: String){
        
        let alert = CDAlertView(title: title, message: message, type: .warning)
        let yesBtn = CDAlertViewAction(title: "Register") { (action) -> Bool in
            self.loginAction()
        }
        if userInfo?.state == "enabled"{
            yesBtn.buttonTitle = "Login"
        }else{
            yesBtn.buttonTitle = "Register"
        }
        alert.add(action: yesBtn)
        
        let noBtn = CDAlertViewAction(title: "Checkout")
        alert.add(action: noBtn)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            if self.isLogin{
                self.isLogin = false
                if self.userInfo?.state == "enabled"{
                    DispatchQueue.main.async {
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                        cv.modalTransitionStyle = .crossDissolve
                        cv.objAddress = self
                        self.present(cv, animated: true, completion: nil)
                    }
                }else{
                    DispatchQueue.main.async {
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp") as! SignUp
                        cv.modalTransitionStyle = .crossDissolve
                        cv.objAddress = self
                        self.present(cv, animated: true, completion: nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
                    //            cv.modalTransitionStyle = .crossDissolve
                    //        self.present(cv, animated: true, completion: nil)
                    self.navigationController?.pushViewController(cv, animated: true)
                }
            }
        }
    }
    
    var isLogin = false
    func loginAction() -> Bool{
        isLogin = true
        return true
    }
    
    func getUserLocation() -> ([String])  {
        
        var latLong : [String] = []
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            if (currentLoc != nil){
                latLong.append("\(currentLoc.coordinate.latitude)")
                latLong.append("\(currentLoc.coordinate.longitude)")
            }else{
                latLong.append("35.702069")
                latLong.append("139.775327")
            }
        }
        return latLong
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setTheme()
        getShippingRates()
        self.txtMobile.delegate = self
        self.tvAddress.delegate = self
        self.title = "Address Information"
        txtAddress.text = "Default Address"
        txtAddress.optionArray = ["Default Address","Alternative Address"]
        txtAddress.selectedIndex = 0
        txtAddress.didSelect{(selectedText , index ,id) in
        self.txtAddress.text = selectedText
            if index == 1 {
                self.tvAddress.text = self.userInfo?.billingAddress?.address2
                self.selectedAddress = 1
            }
            else {
                self.tvAddress.text = self.userInfo?.billingAddress?.address1
                self.selectedAddress = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setTheme(){
        if userToken == nil {
            txtAddress.isEnabled = false
            txtAddress.alpha = 0.5
        }
        
        DispatchQueue.main.async {
            
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            
            self.txtFName.addPadding()
            self.txtFName.layer.cornerRadius = 10
            self.txtFName.clipsToBounds = true
            self.txtFName.layer.borderWidth = 2
            self.txtFName.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtFName.attributedPlaceholder = NSAttributedString(string: "First Name*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtLName.addPadding()
            self.txtLName.layer.cornerRadius = 10
            self.txtLName.clipsToBounds = true
            self.txtLName.layer.borderWidth = 2
            self.txtLName.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtLName.attributedPlaceholder = NSAttributedString(string: "Last Name*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtEmail.addPadding()
            self.txtEmail.layer.cornerRadius = 10
            self.txtEmail.clipsToBounds = true
            self.txtEmail.layer.borderWidth = 2
            self.txtEmail.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtMobile.addPadding()
            self.txtMobile.withFlag = true
            self.txtMobile.withPrefix = true
            self.txtMobile.withExamplePlaceholder = true
            self.txtMobile.layer.cornerRadius = 10
            self.txtMobile.clipsToBounds = true
            self.txtMobile.layer.borderWidth = 2
            self.txtMobile.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            //            self.txtMobile.attributedPlaceholder = NSAttributedString(string: "+92 301 3243432",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtCity.addPadding()
            self.txtCity.layer.cornerRadius = 10
            self.txtCity.clipsToBounds = true
            self.txtCity.layer.borderWidth = 2
            self.txtCity.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtCity.attributedPlaceholder = NSAttributedString(string: "City*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtPostalCode.addPadding()
            self.txtPostalCode.layer.cornerRadius = 10
            self.txtPostalCode.clipsToBounds = true
            self.txtPostalCode.layer.borderWidth = 2
            self.txtPostalCode.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtPostalCode.attributedPlaceholder = NSAttributedString(string: "Zipcode*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtProvince.addPadding()
            self.txtProvince.layer.cornerRadius = 10
            self.txtProvince.clipsToBounds = true
            self.txtProvince.layer.borderWidth = 2
            self.txtProvince.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtProvince.attributedPlaceholder = NSAttributedString(string: "Province*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.txtCountry.addPadding()
            self.txtCountry.layer.cornerRadius = 10
            self.txtCountry.clipsToBounds = true
            self.txtCountry.layer.borderWidth = 2
            self.txtCountry.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtCountry.attributedPlaceholder = NSAttributedString(string: "Country*",attributes: [NSAttributedString.Key.foregroundColor:AppTheme.sharedInstance.Light_Green])
            
            self.tvAddress.layer.cornerRadius = 10
            self.tvAddress.clipsToBounds = true
            self.tvAddress.layer.borderWidth = 2
            self.tvAddress.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.tvAddress.text = "Address*"
            self.tvAddress.textColor = AppTheme.sharedInstance.Light_Green
            
            self.txtAddress.layer.cornerRadius = 10
            self.txtAddress.clipsToBounds = true
            self.txtAddress.layer.borderWidth = 2
            self.txtAddress.layer.borderColor = AppTheme.sharedInstance.Light_Green.cgColor
            self.txtAddress.selectedRowColor = AppTheme.sharedInstance.Light_Green
            
            self.btnSave.layer.cornerRadius = 10
            self.btnSave.clipsToBounds = true
            
            self.viewBG.dropShadow()
            
            //if self.userToken != nil{
                self.setUserData()
            //}
        }
    }
    
    func setUserData(){
        
        if userInfo?.name != ""{
            self.txtFName.text = userInfo?.name ?? userInfo?.billingAddress?.first_name
        }
        if userInfo?.billingAddress?.last_name != ""{
            self.txtLName.text = userInfo?.billingAddress?.last_name
        }
        if userInfo?.email != ""{
            self.txtEmail.text = userInfo?.email ?? userInfo?.billingAddress?.email
        }
        if userInfo?.billingAddress?.phone != ""{
            self.txtMobile.text = userInfo?.billingAddress?.phone
        }else{
            if userInfo?.phoneNumber != ""{
                self.txtMobile.text = userInfo?.phoneNumber ?? userInfo?.billingAddress?.phone
            }
        }
        if userInfo?.billingAddress?.address1 != ""{
            self.tvAddress.text = userInfo?.billingAddress?.address1
            self.tvAddress.textColor = UIColor.darkGray
        }
        if userInfo?.billingAddress?.city != ""{
            self.txtCity.text = userInfo?.billingAddress?.city
        }
        if userInfo?.billingAddress?.zip != ""{
            self.txtPostalCode.text = userInfo?.billingAddress?.zip
        }
        if userInfo?.billingAddress?.province != ""{
            self.txtProvince.text = "Punjab"
        }
        if userInfo?.billingAddress?.country != ""{
            self.txtCountry.text = userInfo?.billingAddress?.country
        }
    }
    
    //MARK: VALIDATIONS
    func checkFiledEmpty()->Bool{
        var valid=true
        
        if(txtFName.text==""){
            txtFName.attributedPlaceholder = NSAttributedString(string: "Provide First Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtLName.text==""){
            txtLName.attributedPlaceholder = NSAttributedString(string: "Provide Last Name",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtMobile.text==""){
            txtMobile.attributedPlaceholder = NSAttributedString(string: "Provide Mobile",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{
            do {
                let phoneNumberKit = PhoneNumberKit()
                let phoneNumber = try phoneNumberKit.parse(txtMobile.text!, withRegion: "PK", ignoreType: true)//try phoneNumberKit.parse(txtMobile.text!)
                print(phoneNumberKit.format(phoneNumber, toType: .e164))
                userPhone = phoneNumberKit.format(phoneNumber, toType: .e164)
            }
            catch {
                print("Invalid Phone Number")
                txtMobile.text = ""
                txtMobile.attributedPlaceholder = NSAttributedString(string: "Invalid Phone Number",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        
        if(txtEmail.text==""){
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Provide email",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }else{
            if !(txtEmail.text!.isValidEmail()){
                txtEmail.text=""
                txtEmail.attributedPlaceholder = NSAttributedString(string: "Email should be valid",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                valid=false
            }
        }
        
        if(tvAddress.text=="" || tvAddress.text=="Address*"){
            tvAddress.text = "Provide Address"
            tvAddress.textColor = .red
            valid=false
        }
        
        if(txtCity.text==""){
            txtCity.attributedPlaceholder = NSAttributedString(string: "Provide City",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtPostalCode.text==""){
            txtPostalCode.attributedPlaceholder = NSAttributedString(string: "Provide Zipcode",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtProvince.text==""){
            txtProvince.attributedPlaceholder = NSAttributedString(string: "Provide Province",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        if(txtCountry.text==""){
            txtCountry.attributedPlaceholder = NSAttributedString(string: "Provide Country",attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
            valid=false
        }
        
        return valid
    }
    
    func hideKeyboard(){
        
        self.txtFName.resignFirstResponder()
        self.txtLName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtMobile.resignFirstResponder()
        self.tvAddress.resignFirstResponder()
        self.txtCity.resignFirstResponder()
        self.txtCountry.resignFirstResponder()
        self.txtProvince.resignFirstResponder()
        self.txtPostalCode.resignFirstResponder()
    }
    
    //MARK: - UITextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Address*" || textView.text == "Provide Address" {
            textView.textColor = .darkGray
            textView.text = nil
        }
    }
    
    //MARK: UITextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(txtMobile){
            let maxLength = 15
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
    
    //MARK: API Calling
    
    func getShippingRates(){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "shipping_zones.json", completion: {js in
            print(js)
            self.getData(json: js)
        })
    }
    
    fileprivate func getData(json:AnyObject){
        
        if json is [String:Any]{
            
            let json = json as! [String: Any]
            if let zones = json["shipping_zones"] as? Array<Any> {
                let rateObject = zones[0] as? [String:Any]
                let rates = rateObject!["price_based_shipping_rates"] as? Array<Any>
                userInfo?.billingAddress?.shipping_rates = [Rate()]
                for i in 0..<rates!.count{
                    let rate = rates![i] as? [String:Any]
                    var rateObject:Rate = Rate()
                    rateObject.name = rate!["name"] as? String
                    rateObject.price = rate!["price"] as? String
                    rateObject.min_order_subtotal = rate!["min_order_subtotal"] as? String
                    rateObject.max_order_subtotal = rate!["max_order_subtotal"] as? String
                    if i == 0{
                        userInfo?.billingAddress?.shipping_rates![i] = rateObject
                    }else{
                        userInfo?.billingAddress?.shipping_rates?.append(rateObject)
                    }
                }
            }
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
                self.activityView.stopAnimating()
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
    
    var isEmail:Bool = false
    func getUserData(query:String){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=\(query)", completion: {js in
            print(js)
            self.getResponseData(json: js)
        })
    }
    
    fileprivate func getResponseData(json:AnyObject){
        
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
                    let addresses = customerObject["addresses"] as? [[String : Any]]
                    if addresses!.count > 0{
                        let count = addresses!.count
                        let address = addresses![count-1]
                        userInfo?.billingAddress?.last_name = address["last_name"] as? String
                        userInfo?.billingAddress?.address1 = address["address1"] as? String
                        userInfo?.billingAddress?.city = address["city"] as? String
                        userInfo?.billingAddress?.zip = address["zip"] as? String
                        userInfo?.billingAddress?.country = address["country"] as? String
                        userInfo?.billingAddress?.province = address["province"] as? String
                    }
                    userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    DispatchQueue.main.async {
                        //                GIFHUD.shared.dismiss()
                        self.activityView.stopAnimating()
                        if !self.getUserLocation().isEmpty {
                            self.userInfo?.billingAddress?.latitude = self.getUserLocation()[0]
                            self.userInfo?.billingAddress?.longitude = self.getUserLocation()[1]
                            self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        }
                        if self.isUpdating{
                            self.isUpdating = false
                            self.updateUserData()
                        }else{
                            self.updateUserData()
                        }
                    }
                }else{
                    if !isUpdating{
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                            if !self.isEmail{
                                self.isEmail = true
                                self.getUserData(query: "email:\(self.userEmail)")
                            }else{
                                self.updateUserData()
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                            self.isUpdating = true
    //                        self.isUpdated = false
                            self.view.makeToast("Server is updating user! Please wait!")
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
        
        let alert = CDAlertView(title: "Alert!", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            DispatchQueue.main.async {
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SummaryVC") as! SummaryVC
                //            cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

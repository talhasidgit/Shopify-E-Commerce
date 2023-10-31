//
//  CartVC.swift
//  Sabzease
//
//  Created by MAC on 31/08/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import SDWebImage
import CDAlertView
import CoreLocation
import NVActivityIndicatorView

@available(iOS 13.0, *)
class CartVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var tblItems: UITableView!
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var locationManager = CLLocationManager()
    var isUpdating: Bool = false
    var totalPrice:Double = 0
    
    @IBAction func actProceed(_ sender: UIButton) {
        
        //        if !isUpdating{
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil{
                self.view.makeToast("Your cart is empty")
            }else{
                //                    if userToken != nil{
                if !getUserLocation().isEmpty {
                    userInfo?.billingAddress?.latitude = self.getUserLocation()[0]
                    userInfo?.billingAddress?.longitude = self.getUserLocation()[1]
                    userInfo?.saveCurrentSession(forKey: USER_MODEL)
                }
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
                cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
                //                    }else{
                //                        showLoginMessage(title: "Alert", message: "Please login to continue!")
                //                    }
            }
        }else{
            if userInfo?.lineItems?.count == 0{
                self.view.makeToast("Your cart is empty")
            }else{
                //                    if userToken != nil{
                userInfo?.billingAddress?.latitude = self.getUserLocation()[0]
                userInfo?.billingAddress?.longitude = self.getUserLocation()[1]
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
                cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
                //                    }else{
                //                        showLoginMessage(title: "Alert", message: "You need to Login first to see orders!")
                //                    }
            }
        }
        //        }else{
        //            isUpdating = false
        //            isUpdated = true
        //            self.getUserData()
        //        }
    }
    
    //    func showLoginMessage(title: String, message: String){
    //
    //        let alert = CDAlertView(title: title, message: message, type: .warning)
    //        let yesBtn = CDAlertViewAction(title: "Login") { (action) -> Bool in
    //            self.loginAction()
    //        }
    //        alert.add(action: yesBtn)
    //        let noBtn = CDAlertViewAction(title: "Cancel")
    //        alert.add(action: noBtn)
    //        alert.isTextFieldHidden = true
    //        alert.hideAnimations = { (center, transform, alpha) in
    //            transform = .identity
    //            alpha = 0
    //        }
    //        alert.show() { (alert) in
    //
    //            if self.isLogin{
    //                DispatchQueue.main.async {
    //                    let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
    //                    cv.modalTransitionStyle = .crossDissolve
    ////                    cv.objMenu = self
    //                    cv.objCartView = self
    //                    self.present(cv, animated: true, completion: nil)
    //                }
    //            }
    //        }
    //    }
    //
    //    var isLogin = false
    //    func loginAction() -> Bool{
    //        isLogin = true
    //        return true
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Cart Items"
        tblItems.estimatedRowHeight = 70
        tblItems.rowHeight = UITableView.automaticDimension
        tblItems.tableFooterView = UIView()
        setTheme()
        setTotalAmount()
        if userToken != nil{
            //getUserData()
        }
    }
    
    func setTheme(){
        
        DispatchQueue.main.async {
            self.btnCheckout.layer.cornerRadius = 20
            self.btnCheckout.clipsToBounds = true
        }
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
    
    //MARK: UITABLEVIEW DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userInfo?.lineItems!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineItemCell", for: indexPath) as! LineItemCell
        
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            cell.lblName.text = self.userInfo?.lineItems![indexPath.row].title?.uppercased()
            if self.userInfo?.lineItems![indexPath.row].size == "Default Title"{
                cell.lblSize.text = "Size: N/A"
            }else{
                cell.lblSize.text = "\(self.userInfo?.lineItems![indexPath.row].size ?? "")"
            }
            cell.lblQTY.text = "\(self.userInfo?.lineItems![indexPath.row].quantity ?? 1)"
            cell.lblPrice.text = "\(String(describing: self.userInfo!.currencyCode!)) \(String(describing: self.userInfo!.lineItems![indexPath.row].price!.withCommas()))"
            cell.imgItem.sd_setImage(with: URL(string: (self.userInfo?.lineItems![indexPath.row].image)!), placeholderImage:UIImage(named: "ic_placeholder")){
                (image, error, cacheType, url) in
                // your code
                print(image ?? "")
            }
            cell.lblTotal.text = "PKR \(((self.userInfo?.lineItems![indexPath.row].price)! * Double((self.userInfo?.lineItems![indexPath.row].quantity)!)).withCommas())"
            cell.btnDel.tag = indexPath.row
            cell.btnDel.addTarget(self, action: #selector(self.delButton(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func delButton(_ sender: UIButton){
        
        userInfo?.lineItems?.remove(at: sender.tag)
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        setTotalAmount()
        tblItems.reloadData()
        if (userInfo?.lineItems!.count)! == 0{
            showMessage()
        }
    }
    
    func showMessage(){
        
        let alert = CDAlertView(title: "Alert!", message: "You have an empty cart", type: .warning)
        let doneBtn = CDAlertViewAction(title: "Okay")
        alert.add(action: doneBtn)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is HomeOldVC {
                    _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: API Calling
    
    func getUserData(){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/search.json?query=email:\(userInfo!.email!)", completion: {js in
            print(js)
            self.getData(json: js)
        })
    }
    
    //    var isUpdated: Bool = false
    fileprivate func getData(json:AnyObject){
        
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
                        //                        if self.isUpdated{
                        self.userInfo?.billingAddress?.latitude = self.getUserLocation()[0]
                        self.userInfo?.billingAddress?.longitude = self.getUserLocation()[1]
                        self.userInfo?.saveCurrentSession(forKey: USER_MODEL)
                        //                            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
                        //                            cv.modalTransitionStyle = .crossDissolve
                        //                            //        self.present(cv, animated: true, completion: nil)
                        //                            self.navigationController?.pushViewController(cv, animated: true)
                        //                        }
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
        }
    }
    
    func setTotalAmount(){
        
        self.totalPrice = 0
        for i in 0..<((userInfo?.lineItems!.count)!){
            let price = self.userInfo!.lineItems![i].price! * Double((self.userInfo?.lineItems![i].quantity)!)
            self.totalPrice = self.totalPrice + Double(price)
        }
        self.btnCheckout.setTitle("Checkout (PKR \(self.totalPrice.withCommas()))", for: .normal)
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


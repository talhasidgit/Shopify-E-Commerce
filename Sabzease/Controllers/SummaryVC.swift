//
//  SummaryVC.swift
//  Sabzease
//
//  Created by MAC on 04/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import CDAlertView
import MobileBuySDK
import NVActivityIndicatorView
import UserNotifications

@available(iOS 13.0, *)
class SummaryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var tblSummary: UITableView!
    var totalPrice:Double = 0
    var subTotal:Double = 0
    var deliveryCharges:Double = 0
    var shippingName = ""
    var discountCode = ""
    var discountType = ""
    var discountValue = "0"
    var isInvalidCode : Bool = false
    var isAlreadyUsed : Bool = false
    var isFirOrder : Bool = false
    var orderID : CLong = 0
    var arr:[String] = []
    var orderObject: Orders!
    var userOrders: [Orders]! = []
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var selectedAddress = 0
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    @IBAction func actDiscount(_ sender: UIButton) {
    }
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Order Summary"
        tblSummary.tableFooterView = UIView()
        if userInfo!.userID != 0{
            getOrderData()
        }
        getTotalAmount()
        setProductsData()
        notificationsPermission()
        center.delegate = self
    }
    func notificationsPermission()  {
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
    func scheduleNotification()  {
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateStyle = .medium
        localDateFormatter.timeStyle = .medium
        
        // No timeZone configuration is required to obtain the
        // local time from DateFormatter.
        
        // Printing a Date
        var date = Date()
        date = date.adding(seconds: 1)
        var dateString = localDateFormatter.string(from: date)
        let localDate = localDateFormatter.date(from: dateString)!
        let content = UNMutableNotificationContent()
        
        content.title = "Congratulations🍎🍋🥦🍅"
        content.body = "Your order has been placed successfully!"
        
        content.sound = UNNotificationSound.default
        // triger notification
        //        let date = Date(timeIntervalSinceNow: 30)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: localDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate as DateComponents, repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        
    }
    
    func getTotalAmount(){
        
        for i in 0..<(userInfo?.lineItems!.count)!{
            let item = userInfo?.lineItems![i]
            subTotal = subTotal + ((item?.price)! * Double((item?.quantity)!))
        }
        
        for i in 0..<(userInfo?.billingAddress?.shipping_rates?.count)!{
            let rate = userInfo?.billingAddress?.shipping_rates![i]
            let price = rate?.price?.toDouble()
            if (subTotal >= (rate?.min_order_subtotal?.toDouble() ?? 0.0)) && (subTotal <= (rate?.max_order_subtotal?.toDouble()) ?? 0.0){
                deliveryCharges = price!
                shippingName = (rate?.name)! as String
            }
        }
        totalPrice = subTotal + deliveryCharges
    }
    
    func setProductsData() {
        
        for i in 0..<(userInfo?.lineItems?.count)!{
            let name = "\(userInfo?.lineItems![i].title ?? "")"
            arr.append(name)
        }
        print(arr)
    }
    
    //MARK: UITABLEVIEW DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
            DispatchQueue.main.async {
                headerCell.viewBG.layer.cornerRadius = 20
                headerCell.viewBG.clipsToBounds = true
                headerCell.viewBG.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                headerCell.viewBG.dropShadow()
            }
            headerCell.viewSep.isHidden = true
            return headerCell
        }else{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
            headerCell.lblName.text = "Shipping to"
            DispatchQueue.main.async {
                headerCell.viewBG.dropShadow()
            }
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            tblSummary.estimatedRowHeight = 30
            tblSummary.rowHeight = UITableView.automaticDimension
            return arr.count
        }else{
            tblSummary.estimatedRowHeight = 380
            tblSummary.rowHeight = UITableView.automaticDimension
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameCell", for: indexPath) as! ProductNameCell
            
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                cell.viewBG.dropShadow()
            }
            cell.lblName.text = arr[indexPath.row]
            cell.lblPrice.text = "PKR \(((self.userInfo?.lineItems![indexPath.row].price)! * Double((self.userInfo?.lineItems![indexPath.row].quantity)!)).withCommas())"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
            
            cell.selectionStyle = .none
            //            cell.lblProdName.attributedText = bulletPointList(strings: arr)
            if selectedAddress == 0 {
                cell.lblShipping.text = "Name:\t\t\(userInfo?.billingAddress?.first_name ?? "") \(userInfo?.billingAddress?.last_name ?? "") \nPhone:\t\t\(userInfo?.billingAddress?.phone ?? userInfo?.phoneNumber ?? "")\nEmail:\t\t\(userInfo?.billingAddress?.email ?? "")\nAddress:\t\(userInfo?.billingAddress?.address1 ?? "")\n\t\t\t\(userInfo?.billingAddress?.city ?? "")\n\t\t\t\(userInfo?.billingAddress?.country ?? "")"
            }
            else {
                cell.lblShipping.text = "Name:\t\t\(userInfo?.billingAddress?.first_name ?? "") \(userInfo?.billingAddress?.last_name ?? "") \nPhone:\t\t\(userInfo?.billingAddress?.phone ?? userInfo?.phoneNumber ?? "")\nEmail:\t\t\(userInfo?.billingAddress?.email ?? "")\nAddress:\t\(userInfo?.billingAddress?.address2 ?? "")\n\t\t\t\(userInfo?.billingAddress?.city ?? "")\n\t\t\t\(userInfo?.billingAddress?.country ?? "")"
            }
            cell.lblProdPrice.text = "PKR \(subTotal.withCommas())"
            if deliveryCharges == 0.0{
                cell.lblWeight.text = "Free"
            }else{
                cell.lblWeight.text = "PKR \(deliveryCharges.withCommas())"
            }
            cell.lblTotalPrice.text = "PKR \(totalPrice.withCommas())"
            cell.btnContinueShopping.addTarget(self, action: #selector(continueShopping), for: .touchUpInside)
            cell.btnCompleteOrder.addTarget(self, action: #selector(completeOrder), for: .touchUpInside)
            cell.btnSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            if isFirOrder{
                self.isApply = true
                self.isInvalidCode = false
                cell.btnSwitch.setOn(true, animated: true)
                cell.btnSwitch.isUserInteractionEnabled = false
            }
            if isInvalidCode{
                cell.btnSwitch.setOn(false, animated: true)
                cell.btnSwitch.isUserInteractionEnabled = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
    
    var isApply : Bool = false
    @objc func switchChanged(mySwitch: UISwitch) {
        let isOn = mySwitch.isOn
        // Do something
        if isOn{
           isApply = true
            //            applyCode()
        }else{
            isApply = false
        }
    }
    
    @objc func continueShopping(){
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is HomeOldVC {
                _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
            }
        }
    }
    
    @objc func completeOrder(){
        
        if isApply{
            if isFirOrder{
                self.discountCode = "ezfresk.pk"
                if userToken == nil {
                    showErrorMessage(message: "Only for ezfresh.pk registered customers!")
                    return
                }
                self.getDiscountData()
            }else{
                applyCode()
            }
        }else{
            checkoutOrder()
        }
    }
    
    func checkoutOrder(){
        var address = ""
        if selectedAddress == 0 {
            address = userInfo?.billingAddress?.address1 ?? ""
        }
        else {
            address = userInfo?.billingAddress?.address2 ?? ""
        }
     
        let param = ["line_items":self.setLineItems(),
                     "customer":self.setCustomer(),
                     "phone":userInfo?.billingAddress?.phone! as Any,
                     "billing_address":["address1":address as AnyObject,
                                        "city":userInfo?.billingAddress?.city as AnyObject,
                                        "country":userInfo?.billingAddress?.country as AnyObject,
                                        "first_name":userInfo?.billingAddress?.first_name as AnyObject,
                                        "last_name":userInfo?.billingAddress?.last_name as AnyObject,
                                        "phone":userInfo?.billingAddress?.phone as AnyObject,
                                        "province":userInfo?.billingAddress?.province as AnyObject,
                                        "zip":userInfo?.billingAddress?.zip as AnyObject,
                                        "latitude": userInfo?.billingAddress?.latitude as Any,
                                        "longitude": userInfo?.billingAddress?.longitude as Any],
                     "shipping_address":["address1":address as AnyObject,
                                         "city":userInfo?.billingAddress?.city as AnyObject,
                                         "country":userInfo?.billingAddress?.country as AnyObject,
                                         "first_name":userInfo?.billingAddress?.first_name as AnyObject,
                                         "last_name":userInfo?.billingAddress?.last_name as AnyObject,
                                         "phone":userInfo?.billingAddress?.phone as AnyObject,
                                         "province":userInfo?.billingAddress?.province as AnyObject,
                                         "zip":userInfo?.billingAddress?.zip as AnyObject,
                                         "latitude": userInfo?.billingAddress?.latitude as Any,
                                         "longitude": userInfo?.billingAddress?.longitude as Any],
                     "financial_status":"pending" as AnyObject,
                     "gateway":"Cash on Delivery (COD) - Only for Pakistan",
                     "inventory_behaviour":"decrement_obeying_policy",
                     "send_receipt":"true",
                     "note":"SENT FROM MOBILE APP",
                     "shipping_lines":[
                        ["price":"\(deliveryCharges)",
                         "title":shippingName]],
                     "discount_codes":setDiscount()
        ] as [String:AnyObject]
        let orderParam = ["order":param] as [String:AnyObject]
        print(orderParam)
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        let url = "https://sabzease.myshopify.com/admin/api/2021-04/orders.json"
        ServerManager.sharedInstance.postRequest(param: orderParam, url: url,fnToken:"", completion: {js,token in
            print(js)
            let addressParams = ["address":["id":self.userInfo?.billingAddress?.addressId as Any,"default":true]]
            //https://sabzease.myshopify.com/admin/api/2021-04/customers/userID/addresses/addressID.json
            ServerManager.sharedInstance.putRequest(param: addressParams, url: ServerManager.sharedInstance.BASE_URL + "customers/\(self.userInfo?.userID ?? 0)/addresses/\(self.userInfo?.billingAddress?.addressId ?? 0).json", completion: { js in
                print(js)
            })
            self.getData(json: js)
            
        })
    }
    
    func setLineItems() -> [[String:AnyObject]]{
        
        var param:[[String:AnyObject]] = []
        for i in 0..<(userInfo?.lineItems?.count)!{
            
            let variantID = userInfo?.lineItems![i].variant_id
            let prm = ["variant_id":variantID!,"quantity":userInfo?.lineItems![i].quantity as Any] as [String:AnyObject]
            param.append(prm)
        }
        return param
    }
    
    func setDiscount() -> [[String:AnyObject]]{
        
        var param:[[String:AnyObject]] = []
        if isApply{
            let prm = ["code":discountCode.uppercased(),
                       "amount":discountValue,
                       "type":discountType] as [String:AnyObject]
            param.append(prm)
            return param
        }else{
            return param
        }
    }
    
    func setCustomer() -> [String:AnyObject]{
        var param:[String:AnyObject]
        if userInfo?.userID == 0{
            let prm = ["first_name":userInfo?.billingAddress?.first_name!,
                       "last_name":userInfo?.billingAddress?.last_name!,
                       "email":userInfo?.billingAddress?.email!
            ] as [String:AnyObject]
            param = prm
        }else{
            let prm = ["id":userInfo?.userID] as [String:AnyObject]
            param = prm
        }
        return param
    }
    
    fileprivate func getData(json:AnyObject){
        
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            
            do {
                let json = json as! [String: Any]
                let orderData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let orderModel = try decoder.decode(OrderResponse.self, from: orderData)
                if let order = orderModel.order {
                    orderObject = order
                }
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                }
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
            
            let json = json as! [String: Any]
            if json.keys.contains("status"){
                let message = json["message"]
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    self.showErrorMessage(message: message as! String)
                }
            }else{
                if let order = json["order"] as? [String:Any] {
                    orderID = (order["order_number"] as! CLong)
                }
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    self.showSuccessMessage()
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
        
        let alert = CDAlertView(title: "Error", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            if self.userToken == nil {
                DispatchQueue.main.async {
                    self.isInvalidCode = true
                    self.isApply = false
                    self.tblSummary.reloadData()
                }
            }
        }
    }
    
    func showSuccessMessage(){
        scheduleNotification()
        let alert = CDAlertView(title: "Order #\(orderID)\n placed successfully!", message: "Thank you for your order. Check My Orders for details", type: .success)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            self.userInfo?.lineItems = [Item()]
            self.userInfo?.lineItems?.removeAll()
            self.userInfo!.saveCurrentSession(forKey: USER_MODEL)
            if self.userToken == nil{
                let controllers = self.navigationController?.viewControllers
                for vc in controllers! {
                    if vc is HomeOldVC {
                        _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    
                    if self.isApply{
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
                        //                self.present(cv, animated: true, completion: nil)
                        //                cv.modalTransitionStyle = .crossDissolve
                        cv.objOrder = self.orderObject
                        cv.isSummary = true
                        self.navigationController?.pushViewController(cv, animated: true)
                    }else{
                        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
                        // self.present(cv, animated: true, completion: nil)
                        // cv.modalTransitionStyle = .crossDissolve
                        self.navigationController?.pushViewController(cv, animated: true)
                    }
                }
            }
        }
    }
    
    func applyCode(){
        
        let alert = CDAlertView(title: "Discount Code", message: "Please enter valid discount code", type: .warning)
        let action = CDAlertViewAction(title: "Done")
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
                DispatchQueue.main.async {
                    self.isDissmiss = false
                    self.isInvalidCode = true
                    self.isApply = false
                    self.tblSummary.reloadData()
                    print("Dismissed")
                }
            }else {
                if alert.textFieldText != "" && alert.textFieldText?.uppercased() != "ezfresh.pk"{
                    self.isInvalidCode = false
                    self.discountCode = alert.textFieldText!
                    self.getDiscountData()
                }else{
                    DispatchQueue.main.async {
                        self.isInvalidCode = true
                        self.isApply = false
                        self.tblSummary.reloadData()
                    }
                }
            }
        }
    }
    
    var isDissmiss = false
    func dissmissAction() -> Bool{
        isDissmiss = true
        return true
    }
    
    func getDiscountData(){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "price_rules.json", completion: {js in
            print(js)
            self.discountData(json: js)
        })
    }
    
    fileprivate func discountData(json:AnyObject){
        
        if json is [String:Any]{
            
            isAlreadyUsed = false
            let json = json as! [String: Any]
            if let discountCodes = json["price_rules"] as? Array<Any> {
                for i in 0..<discountCodes.count{
                    let codeObj = discountCodes[i] as! [String:Any]
                    let codeString = codeObj["title"] as! String
                    
                    if discountCode.uppercased() == codeString.uppercased(){
                        discountType = codeObj["value_type"] as! String
                        discountValue = codeObj["value"] as! String
                        if let endDate = codeObj["ends_at"] as? String {
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let date = dateFormatter.date(from:endDate)!
                            let currentDateTime = Date()
                            if currentDateTime > date  {
                                DispatchQueue.main.async {
                                    self.activityView.stopAnimating()
                                    let alert = UIAlertController(title: "ezfresh.pk", message: "Discount code has been expired!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        self.isInvalidCode = true
                                        self.isApply = false
                                        self.tblSummary.reloadData()
                                        //self.view.makeToast("Invalid Discount Code!")
                                        self.activityView.stopAnimating()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                return
                            }
                        }
                        discountValue = discountValue.components(separatedBy: "-")[1]
                    }
                }
                if discountValue == "0"{
                    DispatchQueue.main.async {
                        self.invalidCodeAlert()
                        
                    }
                }else{
                    for i in 0..<userOrders.count{
                        for j in 0..<userOrders[i].discount_codes!.count{
                            let discountTitle = userOrders[i].discount_codes![j].code
                            if discountCode.uppercased() == discountTitle?.uppercased(){
                                    self.discountValue  = "0"
                                    self.isInvalidCode = true
                                    self.isAlreadyUsed = true
                                    self.isApply = false
                                DispatchQueue.main.async {
                                    self.tblSummary.reloadData()
                                    self.view.makeToast("The \(self.discountCode.uppercased()) code has already been used!")
                                    self.activityView.stopAnimating()
                                }
                            }
                        }
                    }
                    
                    if isAlreadyUsed == false {
                        DispatchQueue.main.async {
                            self.view.makeToast("The discount has been applied! Visit My Orders for details")
                            self.isInvalidCode = false
                            self.activityView.stopAnimating()
                            self.checkoutOrder()
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
    
    func getOrderData(){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "customers/\(userInfo!.userID!)/orders.json", completion: {js in
            print(js)
            self.getResponseData(json: js)
        })
    }
    func invalidCodeAlert()  {
        let alert = UIAlertController(title: "ezfresh.pk", message: "Invalid Discount Code!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.isInvalidCode = true
            self.isApply = false
            self.tblSummary.reloadData()
            //self.view.makeToast("Invalid Discount Code!")
            self.activityView.stopAnimating()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getResponseData(json:AnyObject){
        
        var tempArray: [Orders]! = []
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            
            do {
                let json = json as! [String: Any]
                let orderData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let orderModel = try decoder.decode(OrdersResponse.self, from: orderData)
                userOrders = orderModel.orders
                for i in 0..<userOrders.count{
                    let order = userOrders[i]
                    if order.note?.uppercased() == "SENT FROM MOBILE APP"{
                        tempArray.append(order)
                    }
                }
                if tempArray.count == 0{
                    if userToken != nil && userInfo?.state == "enabled"{
                        isFirOrder = true
                        DispatchQueue.main.async {
                            self.tblSummary.reloadData()
                        }
                    }
                }
                print(isFirOrder)
                print(userOrders.count)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                }
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                }
                let message = json.value(forKey: "message") as! String
                self.showErrorMessage(message: message)
            }
            
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
                self.activityView.stopAnimating()
            }
            let message = json.value(forKey: "message") as! String
            self.showErrorMessage(message: message)
        }
    }
    
}
@available(iOS 13.0, *)
extension SummaryVC: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
}
extension Date {
    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}

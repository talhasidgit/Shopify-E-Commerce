//
//  OrderDetailVC.swift
//  ezfresh.pk
//
//  Created by MAC on 14/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@available(iOS 13.0, *)
class OrderDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var tblOrderDetail: UITableView!
    var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var objOrder: Orders!
    var idArray:[Int] = []
    var qtyArray:[Int] = []
    var isSummary: Bool = false
    var myOrders: MyOrdersVC?
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        
        if isSummary{
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is HomeOldVC {
                    _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Order Detail"
    }
    
    //MARK: UITABLEVIEW DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 110
        }else if section == 1{
            return 175
        }else{
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
            DispatchQueue.main.async {
                headerCell.viewBG.layer.cornerRadius = 20
                headerCell.viewBG.clipsToBounds = true
                headerCell.viewBG.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                headerCell.viewBG.dropShadow()
            }
            
            let orderTime = objOrder.created_at?.components(separatedBy: "T")[1]
            print(orderTime!)
            headerCell.lblOrder.text = "ORDER #\(String(describing: objOrder.order_number!))"
            headerCell.lblOrderDate.text = objOrder.created_at!.components(separatedBy: "T")[0]
            headerCell.lblOrderTime.text = orderTime![0..<5]
            let price = Double(objOrder.total_price!)!.rounded()
            headerCell.lblPrice.text = "PKR \(price.withCommas())"
            let status = objOrder.fulfillment_status
            if status == "fulfilled"{
                headerCell.lblOrderNo.text = "DELIVERED"
            }else if status == nil{
                headerCell.lblOrderNo.text = "PENDING"
            }else{
                headerCell.lblOrder.text = "PARTIALLY DELIVERED"
            }
            
            return headerCell
        }else if section == 1{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "ShippingCell") as! ShippingCell
            DispatchQueue.main.async {
                headerCell.viewBG.dropShadow()
            }
            
            headerCell.lblFullName.text = (self.objOrder.shipping_address?.first_name)! + " " + (self.objOrder.shipping_address?.last_name)!
            headerCell.lblAddress.text = (self.objOrder.shipping_address?.address1)! + " " + (self.objOrder.shipping_address?.city)! + " " + (self.objOrder.shipping_address?.country)!
            return headerCell
        }else{
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as! TotalCell
            DispatchQueue.main.async {
                headerCell.viewBG.layer.cornerRadius = 20
                headerCell.viewBG.clipsToBounds = true
                headerCell.viewBG.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                headerCell.viewBG.dropShadow()
                let itemPrice = Double(self.objOrder.total_line_items_price!)!.rounded()
                headerCell.lblSubTotal.text = "\(itemPrice.withCommas())"
                let discount = Double(self.objOrder.total_discounts!)!.rounded()
                headerCell.lblDiscount.text = "\(discount.withCommas())"
                
                if self.objOrder.shipping_lines![0].price == "0.00"{
                    headerCell.lblShipping.text = "Free"
                    headerCell.lblPKRShipping.isHidden = true
                }else{
                    let shipping = Double(self.objOrder.shipping_lines![0].price!)!.rounded()
                    headerCell.lblShipping.text = "\(shipping.withCommas())"
                    headerCell.lblPKRShipping.isHidden = false
                }
                let total = Double(self.objOrder.total_price!)!.rounded()
                headerCell.lblTotal.text = "\(total.withCommas())"
                headerCell.btnReOrder.addTarget(self, action: #selector(self.actReOrder), for: .touchUpInside)
            }
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 0
        }else if section == 1{
            tblOrderDetail.estimatedRowHeight = 50
            tblOrderDetail.rowHeight = UITableView.automaticDimension
            return self.objOrder.line_items!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProdDetailCell", for: indexPath) as! ProdDetailCell
            
            cell.selectionStyle = .none
            cell.lblProdName.text = self.objOrder.line_items![indexPath.row].title
            cell.lblUnit.text = "(\(String(describing: self.objOrder.line_items![indexPath.row].variant_title!)))"
            cell.lblQty.text = "(\(String(describing: Double(self.objOrder.line_items![indexPath.row].price!)!.withCommas()))) x \(String(describing: self.objOrder.line_items![indexPath.row].quantity!))"
            let qty = Double(self.objOrder.line_items![indexPath.row].quantity!)
            let price = Double(self.objOrder.line_items![indexPath.row].price!)
            cell.lblTotal.text = "\(Double(qty*price!).withCommas())"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProdDetailCell", for: indexPath) as! ProdDetailCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @objc func actReOrder(){
        
        DispatchQueue.main.async {
            
            self.myCalls()
        }
    }
    
    func setCartData(objVariant: Line_items, imageURL: String){
    
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems?[0].title == "" || userInfo?.lineItems![0].title == nil{
                userInfo?.lineItems![0].variant_id = objVariant.variant_id
                userInfo?.lineItems![0].quantity = objVariant.quantity
                userInfo?.lineItems![0].title = objVariant.title
                userInfo?.lineItems![0].price = (objVariant.price! as NSString).doubleValue
                userInfo?.lineItems![0].image = imageURL
                    userInfo?.lineItems![0].size = objVariant.variant_title
                userInfo?.currencyCode = "PKR"
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
//                self.view.makeToast("Product added to cart")
            }else{
                addToCart(objVariant: objVariant, imageURL: imageURL)
            }
        }else{
            addToCart(objVariant: objVariant, imageURL: imageURL)
        }
    }
    
    func addToCart(objVariant: Line_items, imageURL:String){
        
        for i in 0..<(userInfo?.lineItems?.count)!{
            let qty = objVariant.quantity
            let oldQty = (userInfo?.lineItems![i].quantity)!
            if userInfo?.lineItems![i].variant_id == objVariant.variant_id{
                userInfo?.lineItems![i].quantity = oldQty + qty!
                userInfo?.saveCurrentSession(forKey: USER_MODEL)
//                self.view.makeToast("Product added to cart")
                return
            }
        }
        var product:Item = Item()
        product.variant_id = objVariant.variant_id
        product.quantity = objVariant.quantity
        product.title = objVariant.title
        product.price = (objVariant.price! as NSString).doubleValue
        product.image = imageURL
        product.size = objVariant.variant_title
        userInfo?.currencyCode = "PKR"
        userInfo?.lineItems?.append(product)
        userInfo?.currencyCode = "PKR"
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
//        self.view.makeToast("Product added to cart")
    }
    
    //DISPATCH GROUP START
    
    let groupCalls = DispatchGroup()
    
    func myCalls(){

        self.activityView.startAnimating()
        for objVariant in self.objOrder.line_items!{
            groupCalls.enter()
            DispatchQueue.global(qos: .default).async {
                self.getProducts(objVariant: objVariant)
            }
        }
        
        groupCalls.notify(queue: DispatchQueue.main) {
            
            self.activityView.stopAnimating()
            if self.isUnavailable{
                self.isUnavailable = false
                self.myOrders!.fromDetail = true
                self.myOrders!.reOrderMsg = "You can't re-order due to unavailability of some products"
                self.navigationController?.popViewController(animated: true)
            }else{
                for i in 0..<self.itemsArray.count{
                    let item = self.itemsArray[i]
                    self.setCartData(objVariant: item, imageURL: self.imgURLs[i])
                }
                if self.myOrders != nil{
                    self.myOrders!.fromDetail = true
                    self.myOrders!.reOrderMsg = "Available products have been added to your Cart!"
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //DISTPATCH GROUP END
    
    var itemsArray : [Line_items] = []
    var imgURLs : [String] = []
    var isUnavailable: Bool = false
    
    func getProducts(objVariant:Line_items){
        
//        GIFHUD.shared.show()
//        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products/\(objVariant.product_id!).json", completion: {js in
            print(js)
            self.getProductsData(json: js , variant: objVariant)
        })
    }
    
    fileprivate func getProductsData(json:AnyObject , variant: Line_items){
        
        if json is [String:Any]{
            
            let jsn = json as! [String: Any]
            if jsn.keys.contains("status"){
                Utilities.sharedInstance.showAlert(msg: jsn["message"] as! String, title: "Error")
                groupCalls.leave()
            }else{
                
                let decoder = JSONDecoder()
                
                do {
                    let json = json as! [String: Any]
                    let product = json["product"] as! [String:Any]
                    let productsData : Data = try JSONSerialization.data(withJSONObject: product as Any, options: [])
                    let productsModel = try decoder.decode(Products.self, from: productsData)
                    
                    for i in 0..<productsModel.variants!.count{
                        let objProd = productsModel.variants![i]
                        if (objProd.id == variant.variant_id) {
                            if objProd.inventory_quantity != 0{
                                imgURLs.append((productsModel.image?.src)!)
                                itemsArray.append(variant)
                            }else{
                                isUnavailable = true
                            }
                        }
                    }
                } catch let error {
                    
                    print(error)
                    DispatchQueue.main.async {
    //                    GIFHUD.shared.dismiss()
                        self.activityView.stopAnimating()
                    }
                    let message = json.value(forKey: "message") as! String
                    print(message)
                }
                groupCalls.leave()
            }
        }else{
            DispatchQueue.main.async {
//                GIFHUD.shared.dismiss()
//                self.activityView.stopAnimating()
            }
        }
    }
}

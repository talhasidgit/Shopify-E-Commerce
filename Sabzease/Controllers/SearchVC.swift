//
//  SearchVC.swift
//  ezfresh.pk
//
//  Created by Mazhar on 30/07/2021.
//  Copyright © 2021 ExdNow. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import CDAlertView
import Alamofire
@available(iOS 13.0, *)
class SearchVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cvProducts: UICollectionView!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    // MARK: - Variables
    var productList : [Product]?
    var isBaskets:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        addBackBtn()
        layoutSetting(cvProducts)
        txtSearch.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addBadgeCounter()
    }
    //MARK: Custom Methods
    func setTheme()  {
        configureNavigationBar(largeTitleColor: UIColor.white, backgoundColor: AppTheme.sharedInstance.Light_Green, tintColor: .white, title: "SEARCH", preferredLargeTitle: false)
        searchView.dropShadow(scale: true)
    }
    func addBackBtn() {
        let backbutton = UIButton(type: .custom)
        let img = UIImage(named: "back")
        backbutton.setImage(img, for: .normal)
        backbutton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    @objc func backAction()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: Any) {
        if txtSearch.text != "" {
            getProducts(searchTxt: txtSearch.text!)
        }
    }
    
    func addBadgeCounter(){
        
        let userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
        let badgeCount = UILabel(frame: CGRect(x: 22, y: -05, width: 20, height: 20))
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = AppTheme.sharedInstance.Orange
        if userInfo?.lineItems?.count == 1{
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil{
                badgeCount.text = "0"
                badgeCount.isHidden = true
            }else{
                badgeCount.text = "\(userInfo!.lineItems!.count)"
                badgeCount.isHidden = false
            }
        }else if (userInfo?.lineItems!.count)! > 1{
            badgeCount.text = "\(userInfo!.lineItems!.count)"
            badgeCount.isHidden = false
        }else{
            badgeCount.isHidden = true
        }
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBarButton.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(self.onCart), for: .touchUpInside)
        
        rightBarButton.addSubview(badgeCount)
        let rightBarButtomItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    @objc func onCart(){
        
        let userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
        if userInfo?.lineItems?.count == 1{
            
            if userInfo?.lineItems![0].title == "" || userInfo?.lineItems![0].title == nil{
                self.view.makeToast("Your cart is empty")
            }else{
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
                cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
            }
        }else{
            if userInfo?.lineItems?.count == 0{
                self.view.makeToast("Your cart is empty")
            }else{
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
                cv.modalTransitionStyle = .crossDissolve
                //        self.present(cv, animated: true, completion: nil)
                self.navigationController?.pushViewController(cv, animated: true)
            }
        }
    }
    //MARK: API Calling
    
    func getProducts(searchTxt:String){
        
        //        GIFHUD.shared.show()
        DispatchQueue.main.async { [self] in
            activityView.startAnimating()
        }
       
        guard let myUrl = URL(string:ServerManager.sharedInstance.searchProductUrl + "q=\(searchTxt.trimmingCharacters(in: .whitespaces))&resources[type]=product".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            self.showErrorMessage(message: "No results")
            return
        }
        ServerManager.sharedInstance.getRequest(url:  ServerManager.sharedInstance.searchProductUrl + "q=\(searchTxt.trimmingCharacters(in: .whitespaces))&resources[type]=product".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, completion: {js in
            print(js)
            self.getProductsData(json: js)
        })
    }
        
    fileprivate func getProductsData(json:AnyObject){
        
        if json is [String:Any]{
            
            let decoder = JSONDecoder()
            productList = []
            
            do {
                let json = json as! [String: Any]
                let productsData : Data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                let productsModel = try decoder.decode(SearchResponse.self, from: productsData)
                for i in 0..<(productsModel.resources?.results?.products!.count)!{
                    let objProd = productsModel.resources?.results?.products![i]
                        productList?.append(objProd!)
                }
                //                productList = prodxuctsModel.products
                print(productList?.count ?? 0)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                    self.cvProducts.reloadData()
                }
            } catch let error {
                
                print(error)
                DispatchQueue.main.async {
                    //                    GIFHUD.shared.dismiss()
                    self.activityView.stopAnimating()
                }
                let message = json.value(forKey: "message") as? String ?? "something went wrong!"
                self.showErrorMessage(message: message)
            }
            
        }else{
            DispatchQueue.main.async {
                //                GIFHUD.shared.dismiss()
                self.activityView.stopAnimating()
            }
            let message = json.value(forKey: "message") as? String ?? "something went wrong!"
            self.showErrorMessage(message: message)
        }
    }
    
    func showErrorMessage(message:String) {
        
        let alert = CDAlertView(title: "ezfresh.pk", message: message, type: .warning)
        let action = CDAlertViewAction(title: "Okay")
        alert.add(action: action)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        DispatchQueue.main.async {
            alert.show() { (alert) in
                self.activityView.stopAnimating()
            }
        }
    }
    //delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        if txtSearch.text != "" {
            getProducts(searchTxt: txtSearch.text!)
        }
       return true
    }}
//MARK: Collection View Data Source
@available(iOS 13.0, *)
extension SearchVC: UICollectionViewDelegate,UICollectionViewDataSource {
    
    fileprivate func layoutSetting(_ collection:UICollectionView){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20 , bottom: 20, right: 20)
        layout.itemSize = CGSize(width: view.frame.size.width * 0.42, height: 215)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        //        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collection.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if productList?.count == 0 {
            collectionView.setEmptyMessage("No products found")
        } else {
            collectionView.restore()
        }
        return self.productList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.clipsToBounds = true
        cell.dropShadow()
        
        let productObject = productList![indexPath.row]
        cell.lblTItle.text = (productObject.title)?.uppercased()
        if productObject.price == nil{
            cell.lblOriginalPrice.isHidden = true
            cell.viewCross.isHidden = true
            cell.lblPrice.text = "PKR \((productObject.price! as NSString).doubleValue.withCommas()) (\(productObject.title!))"
        }else{
            cell.lblOriginalPrice.isHidden = true
            cell.viewCross.isHidden = true
            cell.lblPrice.text = "PKR \((productObject.price! as NSString).doubleValue.withCommas()) (\(productObject.title!))"
            cell.lblOriginalPrice.text = "PKR \((productObject.price! as NSString).doubleValue.withCommas()) (\(productObject.title!))"
        }
        cell.imgProduct.sd_setImage(with: URL(string: productObject.image ?? ""), placeholderImage:UIImage(named: "ic_placeholder")){
            (image, error, cacheType, url) in
            // your code
            print(image ?? "")
        }
        if !productObject.available {
            cell.lblSoldOut.isHidden = false
            cell.lblPrice.isHidden = true
            cell.lblOriginalPrice.isHidden = true
            cell.viewCross.isHidden = true
        }else{
            cell.lblSoldOut.isHidden = true
            cell.lblPrice.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = productList?[indexPath.row]
        let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        //        cv.modalTransitionStyle = .crossDissolve
        cv.objProductSearch = product
        cv.isFromSearch = true
        cv.productId = "\(product?.id ?? 0)"
        cv.isBaskets = self.isBaskets
        cv.objSearchVC = self
                //self.present(cv, animated: true, completion: nil)
        self.navigationController?.pushViewController(cv, animated: true)
    }
}

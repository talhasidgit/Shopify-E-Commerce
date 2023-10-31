//
//  ProductsVC.swift
//  Sabzease
//
//  Created by MAC on 05/08/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import PageMenu
import CDAlertView
import NVActivityIndicatorView

@available(iOS 13.0, *)
class ProductsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var cvProducts: UICollectionView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    var parentNavController : UINavigationController!
    var productList : [Products]?
    var isBaskets:Bool = false
    var viewTitle = ""
    var collectionID = ""
    @IBOutlet weak var tstImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTheme()
        getProducts(collectID: collectionID)
        layoutSetting(cvProducts)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: Custom Methods
    
    func setTheme(){
        
        //        if (self.title == "FRUITS" || self.title == "VEGETABLES"){
        
        //            self.segControl.isHidden = false
        //            self.topMargin.constant = 64
        //        }else{
        self.segControl.isHidden = true
        self.topMargin.constant = 12
        //        }
        configureNavigationBar(largeTitleColor: UIColor.white, backgoundColor: AppTheme.sharedInstance.Light_Green, tintColor: AppTheme.sharedInstance.Light_Green, title: viewTitle, preferredLargeTitle: false)
        //        GIFHUD.shared.setGif(named: AppConstatns.sharedInstance.apiGif)
        
        // Change Segment Text Color on Selection
        //        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
    }
    
    //MARK: UIButton Actions
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actSegment(_ sender: UISegmentedControl) {
        
        //        if sender.selectedSegmentIndex == 0{
        //            isFruits = true
        //            if fruiteList?.count == 0{
        //                self.getProducts(collectID: fruiteID)
        //            }else{
        //                cvProducts.reloadData()
        //            }
        //        }else{
        //            isFruits = false
        //            if vegList?.count == 0{
        //                self.getProducts(collectID: vegID)
        //            }else{
        //                cvProducts.reloadData()
        //            }
        //        }
    }
    
    //MARK: Collection View Data Source
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
        if productObject.variants![0].compare_at_price == nil{
            cell.lblOriginalPrice.isHidden = true
            cell.viewCross.isHidden = true
            cell.lblPrice.text = "PKR \((productObject.variants![0].price! as NSString).doubleValue.withCommas()) (\(productObject.variants![0].title!))"
        }else{
            let comparePrice:Float? = Float(productObject.variants![0].compare_at_price ?? "0") // firstText is UITextField
            let origionalPrice:Float? = Float(productObject.variants![0].price ?? "0")
            if origionalPrice! < comparePrice! {
                cell.lblOriginalPrice.isHidden = false
                cell.viewCross.isHidden = false
                cell.lblPrice.text = "PKR \((productObject.variants![0].price! as NSString).doubleValue.withCommas()) (\(productObject.variants![0].title!))"
                cell.lblOriginalPrice.text = "PKR \((productObject.variants![0].compare_at_price! as NSString).doubleValue.withCommas()) (\(productObject.variants![0].title!))"
                
            }
            else {
                cell.lblOriginalPrice.isHidden = true
                cell.viewCross.isHidden = true
                cell.lblPrice.text = "PKR \((productObject.variants![0].price! as NSString).doubleValue.withCommas()) (\(productObject.variants![0].title!))"
            }
           
        }
        cell.imgProduct.sd_setImage(with: URL(string: productObject.image?.src ?? ""), placeholderImage:UIImage(named: "ic_placeholder")){
            (image, error, cacheType, url) in
            // your code
            print(image ?? "")
        }
        if productObject.variants![0].inventory_quantity == 0{
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
        cv.objProduct = product
        cv.isBaskets = self.isBaskets
        
        cv.objProductsVC = self
        //        self.present(cv, animated: true, completion: nil)
        self.parentNavController?.pushViewController(cv, animated: true)
    }
    
    //MARK: API Calling
    
    func getProducts(collectID:String){
        
        //        GIFHUD.shared.show()
        activityView.startAnimating()
        ServerManager.sharedInstance.getRequest(url: ServerManager.sharedInstance.BASE_URL + "products.json?collection_id=\(collectID)&limit=250", completion: {js in
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
                let productsModel = try decoder.decode(ProductsResponse.self, from: productsData)
                for i in 0..<productsModel.products!.count{
                    let objProd = productsModel.products![i]
                    if (objProd.published_at != nil) {
                        productList?.append(objProd)
                    }
                }
                //                productList = productsModel.products
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
}

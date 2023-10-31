//
//  HomeVC.swift
//  ezfresh.pk
//
//  Created by MAC on 30/07/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import PageMenu
import SideMenu
import SDWebImage
import CDAlertView
import Reachability

@available(iOS 13.0, *)
class HomeVC: UIViewController, CAPSPageMenuDelegate {
    
    var collectionList:[Smart_collections]?
    var currentIndex = 0
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTheme()
        setPageMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addBadgeCounter()
    }
    
    //MARK: PageMenu Setup
    
    func setPageMenu(){
        
        var controllerArray : [UIViewController] = []
        for i in 0..<collectionList!.count{
            
            let collectObj = collectionList![i]
            let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
            cv.title = (collectObj.title?.uppercased())!
            cv.parentNavController = self.navigationController
            cv.collectionID = String(collectObj.id!)
            if (collectObj.title?.uppercased())! == "SPECIAL DEALS"{
                cv.isBaskets = true
            }else{
                cv.isBaskets = false
            }
            controllerArray.append(cv)
        }
        let parameters: [CAPSPageMenuOption] = [
        .enableHorizontalBounce(true),
        .menuHeight(50),
        .addBottomMenuHairline(true),
            .menuItemWidthBasedOnTitleTextWidth(true),
        .selectionIndicatorColor(Utilities.sharedInstance.hexStringToUIColor(hex: "#ffffff")),
        .selectedMenuItemLabelColor(Utilities.sharedInstance.hexStringToUIColor(hex: "#ffffff")),
        .unselectedMenuItemLabelColor(Utilities.sharedInstance.hexStringToUIColor(hex: "#E1E1E1")),
        .scrollMenuBackgroundColor(AppTheme.sharedInstance.Light_Green),
        .bottomMenuHairlineColor(.lightGray)
        ]//86C33E

        self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.pageMenu?.moveToPage(currentIndex)
        self.view.addSubview(self.pageMenu!.view)
    }
        
    //MARK: Custom Methods
    
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
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchButton.setBackgroundImage(UIImage(named: "search icon white"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchBtn), for: .touchUpInside)
        let rightBarButtomItem2 = UIBarButtonItem(customView: searchButton)
        
        let whatsAppButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        whatsAppButton.setBackgroundImage(UIImage(named: "whatsapp icon"), for: .normal)
        whatsAppButton.addTarget(self, action: #selector(self.whatsAppBtn), for: .touchUpInside)
        let rightBarButtomItem3 = UIBarButtonItem(customView: whatsAppButton)
        
        navigationItem.rightBarButtonItems = [rightBarButtomItem,rightBarButtomItem2,rightBarButtomItem3]
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
    @objc func whatsAppBtn() {
        let myUrl = "https://api.whatsapp.com/send?phone=+923334377341"
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @objc func searchBtn() {
        DispatchQueue.main.async {
            let vc=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.modalTransitionStyle = .crossDissolve
            vc.title = "SEARCH"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func setTheme(){
        
        configureNavigationBar(largeTitleColor: UIColor.white, backgoundColor: AppTheme.sharedInstance.Light_Green, tintColor: AppTheme.sharedInstance.Light_Green, title: "PRODUCTS", preferredLargeTitle: false)
        
        if self.traitCollection.userInterfaceStyle == .dark {
//            SKActivityIndicator.spinnerColor(.white)
        } else {
//            SKActivityIndicator.spinnerColor(.black)
        }
    }
    
    //MARK: UIButton Actions
    
    @IBAction func actMenu(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

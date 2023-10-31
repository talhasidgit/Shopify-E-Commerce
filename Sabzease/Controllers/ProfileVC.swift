//
//  ProfileVC.swift
//  ezfresh.pk
//
//  Created by MAC on 07/10/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import CDAlertView
import iOSDropDown
import NVActivityIndicatorView
@available(iOS 13.0, *)
class ProfileVC: UIViewController {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtDefaultAddress: UITextView!
    @IBOutlet weak var txtAlternativeAddress: UITextView!
    @IBOutlet weak var txtCity: DropDown!
    @IBOutlet weak var alternativeCity: DropDown!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    var objHome: HomeOldVC?
    var isReset : Bool = false
    var userInfor = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
    var userToken = Utilities.sharedInstance.getTokenSession(forKey: USER_TOKEN_KEY)
    var saveBtn = UIBarButtonItem()
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    @IBAction func actBtns(_ sender: UIButton) {
        
        if sender.isEqual(self.btnLogout){
            
            DispatchQueue.main.async {
                self.showMessage(title: "Confirmation!", message: "Are you sure you want to logout?")
            }
        }else{
            DispatchQueue.main.async {
                let cv=UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
                cv.modalTransitionStyle = .crossDissolve
                cv.objProfile = self
                self.present(cv, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actBack(_ sender: UIBarButtonItem) {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is HomeOldVC {
                _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Account"
        saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        saveBtn.isEnabled = false
        navigationItem.rightBarButtonItem = saveBtn
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        txtDefaultAddress.delegate = self
        txtAlternativeAddress.delegate = self
        setTheme()
    }
    
    @objc func saveTapped() {
        var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
        userInfo?.billingAddress?.address1 = txtDefaultAddress.text
        userInfo?.billingAddress?.address2 = txtAlternativeAddress.text
        userInfo?.saveCurrentSession(forKey: USER_MODEL)
        let addressParams = ["address":["id":userInfo?.billingAddress?.addressId as Any,"address1":userInfo?.billingAddress?.address1 as Any]]
        activityView.startAnimating()
        ServerManager.sharedInstance.putRequest(param: addressParams, url: ServerManager.sharedInstance.BASE_URL + "customers/\(userInfo?.userID ?? 0)/addresses/\(userInfo?.billingAddress?.addressId ?? 0).json", completion: { js in
            print(js)
            self.activityView.stopAnimating()
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.view.makeToast("Profile updated successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func setTheme() {
        
        DispatchQueue.main.async {
            self.viewBG.layer.cornerRadius = 10
            self.viewBG.clipsToBounds = true
            self.viewBG.dropShadow()
            self.btnReset.layer.cornerRadius = 10
            self.btnReset.clipsToBounds = true
            self.btnLogout.layer.cornerRadius = 10
            self.btnLogout.layer.borderWidth = 2
            self.btnLogout.layer.borderColor = AppTheme.sharedInstance.Orange.cgColor
            self.btnLogout.setTitleColor(AppTheme.sharedInstance.Orange, for: .normal)
            self.btnLogout.backgroundColor = UIColor.white
            self.btnLogout.clipsToBounds = true
            self.txtDefaultAddress.layer.cornerRadius = 10
            self.txtDefaultAddress.clipsToBounds = true
            self.txtDefaultAddress.layer.borderWidth = 0.3
            self.txtDefaultAddress.layer.borderColor = UIColor.lightGray.cgColor
            
            self.txtAlternativeAddress.layer.cornerRadius = 10
            self.txtAlternativeAddress.clipsToBounds = true
            self.txtAlternativeAddress.layer.borderWidth = 0.3
            self.txtAlternativeAddress.layer.borderColor = UIColor.lightGray.cgColor
            
            self.setUserData()
        }
    }
    
    func setUserData(){
        
        self.lblFName.text = userInfor?.name
        self.lblEmail.text = userInfor?.email
        self.lblPhone.text = userInfor?.phoneNumber
        self.txtDefaultAddress.text = "\(userInfor?.billingAddress?.address1 ?? "") "
        self.txtAlternativeAddress.text = "\(userInfor?.billingAddress?.address2 ?? "") "
        self.txtCity.text = "\(userInfor?.billingAddress?.city ?? ""),\(userInfor?.billingAddress?.country ?? "")"
        self.alternativeCity.text = "Lahore,Pakistan"
        txtCity.optionArray = ["Lahore,Pakistan"]
        txtCity.selectedIndex = 0
        txtCity.didSelect{(selectedText , index ,id) in
            self.txtCity.text = selectedText
        }
        alternativeCity.optionArray = ["Lahore,Pakistan"]
        alternativeCity.selectedIndex = 0
        alternativeCity.didSelect{(selectedText , index ,id) in
            self.alternativeCity.text = selectedText
        }
    }
    
    func showMessage(title: String, message: String){
        
        let alert = CDAlertView(title: title, message: message, type: .warning)
        let yesBtn = CDAlertViewAction(title: "Yes") { (action) -> Bool in
            self.logoutAction()
        }
        alert.add(action: yesBtn)
        let noBtn = CDAlertViewAction(title: "No")
        alert.add(action: noBtn)
        alert.isTextFieldHidden = true
        alert.hideAnimations = { (center, transform, alpha) in
            transform = .identity
            alpha = 0
        }
        alert.show() { (alert) in
            
            if self.isYes{
                DispatchQueue.main.async {
                    if self.userToken != nil{
                        Utilities.sharedInstance.removeSession(forKey: USER_TOKEN_KEY)
                        Utilities.sharedInstance.removeSession(forKey: USER_MODEL)
                        var userInfo = Utilities.sharedInstance.getUserData(forKey: USER_MODEL)
                        userInfo = UserModel()
                        userInfo!.saveCurrentSession(forKey: USER_MODEL)
                    }
                    self.dismiss(animated: true) {
                        if self.objHome != nil{
                            self.objHome?.addBadgeCounter()
                            self.objHome?.view.makeToast("Logged out successfully!")
                            let controllers = self.navigationController?.viewControllers
                            for vc in controllers! {
                                if vc is HomeOldVC {
                                    _ = self.navigationController?.popToViewController(vc as! HomeOldVC, animated: true)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    var isYes = false
    func logoutAction() -> Bool{
        isYes = true
        return true
    }
}
@available(iOS 13.0, *)
extension ProfileVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        saveBtn.isEnabled = true
    }
}

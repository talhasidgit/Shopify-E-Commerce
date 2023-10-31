//
//  AppConstants.swift
//  Rang Rasiya
//
//  Created by Zain Ali on 11/07/2018.
//  Copyright © 2018 A2L. All rights reserved.
//

import Foundation

class AppTheme {
    
    static var sharedInstance = AppTheme()
    //MARK: - COLORS
    var LBL_GRAY        = Utilities.sharedInstance.hexStringToUIColor(hex: "#a3a4a6")
    var LBL_SEP_GRAY    = Utilities.sharedInstance.hexStringToUIColor(hex: "#dcdcdc")
    var LBL_RED         = Utilities.sharedInstance.hexStringToUIColor(hex: "#ff2b21")
    var LBL_BLACK       = Utilities.sharedInstance.hexStringToUIColor(hex: "#000000")
    var LBL_WHITE       = UIColor.white
    var LBL_BLUE        = Utilities.sharedInstance.hexStringToUIColor(hex: "#3B5998")
    var LBL_DARK_GRAY   = UIColor.darkGray
    var COMPLETE        = Utilities.sharedInstance.hexStringToUIColor(hex: "#29aa62")
    var PENDING         = Utilities.sharedInstance.hexStringToUIColor(hex: "#ff8a00")
    var CANCEL          = Utilities.sharedInstance.hexStringToUIColor(hex: "#dd2a2a")
    var Light_Green     = Utilities.sharedInstance.hexStringToUIColor(hex: "#7E8C01")
    var Dark_Green      = Utilities.sharedInstance.hexStringToUIColor(hex: "#86C33E")
    var Orange          = Utilities.sharedInstance.hexStringToUIColor(hex: "#FF6D00")
    var Gray            = Utilities.sharedInstance.hexStringToUIColor(hex: "#BDBDBD")
    
}

//MARK: - AppConstants
class AppConstatns{
    
    static var sharedInstance = AppConstatns()
    var BASE_IMAGE_URL          = "https://rangrasiya.com.pk/pub/media/catalog/product/"
    var ProductAdded            = "Product added in your cart successfully."
    var WishListAdded           = "Product added in your wishlist successfully."
    var ProductRemoved          = "Product removed from your cart."
    var WishListRemoved         = "Product removed from your wishlist."
    var SelectOneProduct        = "Please select at-least one item"
    var BagEmpty                = "Your bag is empty."
    var NoCategory              = "There is no category available."
    var NoAddress               = "You haven't added any address. Please add an address to complete this process"
    var InValidCoupon           = "Invalid Coupon Code"
    var UpdatePassword          = "Password updated successfully"
    var Pending                 = "awaiting confirmation"
    var Cancelled               = "Cancelled"
    var Placed                  = "Placed"
    var InProcess               = "Processing"
    var Shipped                 = "Shipped"
    var Delivered               = "Delivered"
    var apiGif                  = "loader.gif"
    var imgGif                  = "logo-animation"
    var isReviewd               = "isReviewd"
    var splashLoader            = "splash-animation.gif"
    
}

//MARK: - AppFont

class AppFont{
    
    static var sharedInstance = AppFont()
    
    func get_BebasRegular(size: CGFloat) -> UIFont?{
        return UIFont(name: "BebasNeueRegular", size: size)
    }
    func get_BebasLight(size: CGFloat) -> UIFont?{
        return UIFont(name: "BebasNeueLight", size: size)
    }
    func get_BebasThin(size: CGFloat) -> UIFont?{
        return UIFont(name: "BebasNeueThin", size: size)
    }
    func get_BebasBook(size: CGFloat) -> UIFont?{
        return UIFont(name: "BebasNeueBook", size: size)
    }
    func get_BebasBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "BebasNeueBold", size: size)
    }
    func get_MontBlack(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-Black", size: size)
    }
    func get_MontBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-Bold", size: size)
    }
    func get_MontSemiBold(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-SemiBold", size: size)
    }
    func get_MontRegular(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-Regular", size: size)
    }
    func get_MontMedium(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-Medium", size: size)
    }
    func get_MontMediumItalic(size: CGFloat) -> UIFont?{
        return UIFont(name: "Montserrat-MediumItalic", size: size)
    }
}

//MARK: - SEGUES
class AppSegues {
    
    static var sharedInstance = AppSegues()
    
    var LOGINSEGUE                      = "LoginVC"
    var SIGNUPSEGUE                     = "SignUpVC"
    var HOMESEGUE                       = "SWRevealViewController"
    var SETTINGSEGUE                    = "SettingVC"
    var WISHLISTSEGUE                   = "WishListVC"
    var NOTIFICATIONSEGUE               = "NotificationsVC"
    var ABOUTSEGUE                      = "AboutUsVC"
    var CONTACTSEGUE                    = "ContactUsVC"
    var PRODUCTDETAILSEGUE              = "ProductDetailVC"
    var BAGSEGUE                        = "BagVC"
    var CHECKOUTSEGUE                   = "CheckoutVC"
    var ADDRESSSEGUE                    = "AddressVC"
    var SPECIALCOLLECTIONSEGUE          = "SpecialVC"
    var FAQSEGUE                        = "FaqsVC"
    var PROFILESEGUE                    = "ProfileVC"
    var EDITPROFILESEGUE                = "EditProfileVC"
    var FPSEGUE                         = "FPVC"
    var ORDERDETAILSEGUE                = "OrderDetailVC"
    var PRIVACYSEGUE                    = "PrivacyVC"
    var CHATSEGUE                       = "ChatVC"
    var ZOOMSEGUE                       = "ZoomVC"
}

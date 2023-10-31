//
//  AppDelegate.swift
//  ezfresh.pk
//
//  Created by MAC on 30/07/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import UIKit
import Bolts
import CoreData
import Firebase
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift
import FBSDKCoreKit
@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        Thread.sleep(forTimeInterval: 0.01)
        IQKeyboardManager.shared.enable = true
        registerPushNotifications(application)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    //MARK: USer Notifications Delegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "ezfresh.pk") { error in
          print("Subscribed to ezfresh.pk topic")
        }
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        let response = notification.request.content.userInfo as! [String: Any]
        print(response["order_uuid"] ?? "Empty")
        print(notification.request.content.userInfo)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("handling notification")
        let resp = response.notification.request.content.userInfo as! [String: Any]
        print(resp["order_uuid"] ?? "Empty")
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    // MARK: FACEBOOK EVENTS
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let parsedUrl = BFURL.init(inboundURL: url, sourceApplication: sourceApplication)

        if (parsedUrl?.targetURL.pathComponents[1] == "profiles") {
            // Open a profile viewer.
        }
        // Apps can easily check the Extras and App Link data from the App Link as well.
        let fbAccessToken = parsedUrl?.appLinkExtras["fb_access_token"] as? String
        print("FBAccessToken = \(fbAccessToken ?? "")")
        let refererData = parsedUrl?.appLinkExtras["referer"] as? [AnyHashable : Any]
        print("FBRefererData = \(refererData!)")
        
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (url.host == "oauth-callback") {
//            OAuthSwift.handle(url: url)
//        }
//        return true
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        AppEvents.activateApp()
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "ezfresh.pk")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


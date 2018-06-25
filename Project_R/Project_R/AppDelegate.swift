//
//  AppDelegate.swift
//  SarvodayaHB
//
//  Created by CZ Ltd on 12/13/17.
//  Copyright © 2017 CZ Ltd. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // change the tint color on the Tab Bar to Wet Asphalt
//
//        UNUserNotificationCenter.current().delegate = self as! UNUserNotificationCenterDelegate
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            print("granted: (\(granted)")
//        }
        
        UIApplication.shared.registerForRemoteNotifications() //(I)
        
        UITabBar.appearance().tintColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        
        
        // Connect to Firebase content
        FirebaseApp.configure()
        //        try! Auth.auth().signOut()
        
        //        if Auth.auth().currentUser != nil {
        //
        //            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        //            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarID")
        //            self.window = UIWindow(frame: UIScreen.main.bounds)
        //            self.window?.rootViewController = controller
        //            self.window?.makeKeyAndVisible()
        //
        //        }

        
        
        var initialViewController: UIViewController?
        if let username = UserDefaults.standard.value(forKey: "emailTextField") {
        if Auth.auth().currentUser != nil {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)

            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarID")
        } else {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Start", bundle: nil)

            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController")
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        Thread.sleep(forTimeInterval: 3.0)
    }
        
        return true
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token: \(token)")
        // Convert token to string
        _ = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Auth.auth().setAPNSToken((deviceToken as NSData) as Data, type: AuthAPNSTokenType.sandbox)
    }
    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("failed to register for remote notifications with with error: \(error)")
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


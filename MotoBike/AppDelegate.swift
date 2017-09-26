//
//  AppDelegate.swift
//  MotoBike
//
//  Created by 川口日成 on 2017/8/28.
//  Copyright © 2017年 Cherry. All rights reserved.
//

import UIKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 得到當前應用的 App 版本
        let infoDictionary = Bundle.main.infoDictionary
        
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的 App 版本
        let userDefaults = UserDefaults.standard
        
        let appVersion = userDefaults.string(forKey: "appVersion")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 如果 appVersion 為 nil 說明是第一次啟動 App
        // 如果 appVersion != currentAppVersion，代表更新過了
        if(appVersion == nil || appVersion != currentAppVersion) {
            // 保存最新的 App 版本
            userDefaults.set(currentAppVersion, forKey: "appVersion")
            
            let guideViewController = storyboard.instantiateViewController(withIdentifier: "firstStartAppViewController") as! firstStartAppViewController
            self.window?.rootViewController = guideViewController
            
        } else {
            
            let MapVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "MapViewController")
            self.window?.rootViewController = MapVC
            
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    
    }

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


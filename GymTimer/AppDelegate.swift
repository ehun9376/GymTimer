//
//  AppDelegate.swift
//  GymTimer
//
//  Created by 陳逸煌 on 2023/6/30.
//

import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SKPaymentQueue.default().add(IAPCenter.shared)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        if UserInfoCenter.shared.loadValue(.iaped) == nil {
            UserInfoCenter.shared.storeValue(.iaped, data: 3)
        }
        return true
    }



}


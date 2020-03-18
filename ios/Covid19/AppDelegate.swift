//
//  AppDelegate.swift
//  Covid19
//
//  Created by Per Thomas Haga on 17/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}


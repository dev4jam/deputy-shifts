//
//  AppDelegate.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import UIKit
import RIBs

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        
        let appComponent = AppComponent(application: application, launchOptions: launchOptions)
        let rib = RootBuilder(dependency: appComponent).build()
        
        launchRouter = rib
        
        rib.launchFromWindow(window)

        return true
    }
}


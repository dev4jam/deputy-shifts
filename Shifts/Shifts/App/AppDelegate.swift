//
//  AppDelegate.swift
//  Shifts
//
//  Created by Dmitry Klimkin on 24/11/18.
//  Copyright © 2018 Dmitry Klimkin. All rights reserved.
//

import UIKit
import RIBs
import RxSwift

enum AppState {
    case launched
    case terminated
    case background
    case foreground
    case active
    case inactive
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var launchRouter: LaunchRouting?
    private var state: Variable<AppState> = Variable(.inactive)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        state.value = .launched

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        
        let appComponent = AppComponent(application: application,
                                        launchOptions: launchOptions,
                                        state: state)
        
        let rib = RootBuilder(dependency: appComponent).build()
        
        launchRouter = rib
        
        rib.launchFromWindow(window)

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        state.value = .background
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        state.value = .foreground
    }

    func applicationWillTerminate(_ application: UIApplication) {
        state.value = .terminated
    }
}


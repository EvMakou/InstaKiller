//
//  AppDelegate.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let appComponent = AppComponent()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        let rootRouter = RootBuilder().build(appComponent: appComponent)
        rootRouter.launchInWindow(window)
        
        return true
    }
}


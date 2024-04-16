//
//  RootRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit.UIWindow

protocol RootRouting: LaunchRouting {
    var viewController: RootControllable { get }
    
    func routeToSplashScreen(delegate: SplashDelegate)
    func routeToMainScreen()
}

final class RootRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: RootControllable
    
    private var currentChildViewController: ViewControllable?
    
    init(appComponent: AppComponent, viewController: RootControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension RootRouter: RootRouting {
    func launchInWindow(_ window: UIWindow) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
    }
    
    func routeToSplashScreen(delegate: SplashDelegate) {
        let splashChild = SplashBuilder().build(appComponent: appComponent, delegate: delegate)
        splashChild.modalPresentationStyle = .fullScreen
        viewController.attachChild(viewController: splashChild)
        currentChildViewController = splashChild
    }
    
    func routeToMainScreen() {
        let customTabBarChild = MainScreenBuilder().build(appComponent: appComponent)
        customTabBarChild.modalPresentationStyle = .fullScreen
        if let currentChildViewController {
            viewController.detachChild(viewController: currentChildViewController)
        }
        viewController.attachChild(viewController: customTabBarChild)
        currentChildViewController = customTabBarChild
    }
}

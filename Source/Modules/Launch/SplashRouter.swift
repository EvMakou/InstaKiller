//
//  SplashRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

protocol SplashRouting: ViewRouting {
    var viewController: SplashControllable { get }
}

final class SplashRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: SplashControllable
    
    init(appComponent: AppComponent, viewController: SplashControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension SplashRouter: SplashRouting {}

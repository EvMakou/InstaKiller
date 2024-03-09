//
//  MainScreenRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import Foundation

protocol MainScreenRouting: ViewRouting {
    var viewController: MainScreenControllable { get }
}

final class MainScreenRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: MainScreenControllable
    
    init(appComponent: AppComponent, viewController: MainScreenControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension MainScreenRouter: MainScreenRouting {}

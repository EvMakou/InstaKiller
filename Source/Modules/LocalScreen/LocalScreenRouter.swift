//
//  LocalScreenRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 15.04.24.
//

import Foundation

protocol LocalScreenRouting: ViewRouting {
    var viewController: LocalScreenControllable { get }
}

final class LocalScreenRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: LocalScreenControllable
    
    init(appComponent: AppComponent, viewController: LocalScreenControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension LocalScreenRouter: LocalScreenRouting {}

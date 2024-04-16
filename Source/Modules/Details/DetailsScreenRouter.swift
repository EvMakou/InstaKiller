//
//  DetailsScreenRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

protocol DetailsScreenRouting: ViewRouting {
    var viewController: DetailsScreenControllable { get }
}

final class DetailsScreenRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: DetailsScreenControllable
    
    init(appComponent: AppComponent, viewController: DetailsScreenControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension DetailsScreenRouter: DetailsScreenRouting {}

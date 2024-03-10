//
//  MainScreenRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import Foundation

protocol MainScreenRouting: ViewRouting {
    var viewController: MainScreenControllable { get }
    
    func routeToDetailsScreen(fileName: String, listener: MainScreenListener)
}

final class MainScreenRouter {
    private(set) var appComponent: AppComponent
    private(set) unowned var viewController: MainScreenControllable
    
    init(appComponent: AppComponent, viewController: MainScreenControllable) {
        self.appComponent = appComponent
        self.viewController = viewController
    }
}

extension MainScreenRouter: MainScreenRouting {
    func routeToDetailsScreen(fileName: String, listener: MainScreenListener) {
        let details = DetailsScreenBuilder().build(appComponent: appComponent, fileName: fileName, listener: listener)
        viewController.navigationController?.pushViewController(details, animated: true)
    }
}

//
//  MainScreenRouter.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

protocol MainScreenRouting: ViewRouting {
    var viewController: MainScreenControllable { get }
    
    func routeToDetailsScreen(imageIndex: Int)
    func routeToLocalScreen()
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
    func routeToDetailsScreen(imageIndex: Int) {
        let details = DetailsScreenBuilder().build(appComponent: appComponent, imageIndex: imageIndex)
        viewController.navigationController?.pushViewController(details, animated: true)
    }
    
    func routeToLocalScreen() {
        let local = LocalScreenBuilder().build(appComponent: appComponent)
        //viewController.navigationController?.pushViewController(local, animated: true)
        viewController.present(local, animated: true)
    }
}

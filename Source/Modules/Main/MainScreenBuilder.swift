//
//  MainScreenBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

final class MainScreenBuilder {
    func build(appComponent: AppComponent) -> NavigationController {
        guard let vc = UIStoryboard(name: "MainScreen", bundle: .main).instantiateInitialViewController() as? MainScreenViewController else {
            fatalError("Unable to instantiate MainVC")
        }
        
        let router = MainScreenRouter(appComponent: appComponent, viewController: vc)
        let interactor = MainScreenInteractor(presenter: vc, router: router)
        vc.interactor = interactor
        
        return NavigationController(rootViewController: vc)
    }
}

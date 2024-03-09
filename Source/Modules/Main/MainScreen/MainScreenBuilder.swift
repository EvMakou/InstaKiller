//
//  MainScreenBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

final class MainScreenBuilder {
    func build(appComponent: AppComponent) -> NavigationController {
        guard let vc = UIStoryboard(name: "MainScreen", bundle: .main).instantiateInitialViewController() as? MainScreenViewController else {
            fatalError("Unable to instantiate RootVC")
        }
        
        let router = MainScreenRouter(appComponent: appComponent, viewController: vc)
        let interactor = MainScreenInteractor(presenter: vc, router: router)
        vc.interactor = interactor
        
        return NavigationController(rootViewController: vc)
    }
}

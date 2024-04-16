//
//  LocalScreenBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 15.04.24.
//

import UIKit

final class LocalScreenBuilder {
    func build(appComponent: AppComponent) -> NavigationController {
        guard let vc = UIStoryboard(name: "LocalScreen", bundle: .main).instantiateInitialViewController() as? LocalScreenViewController else {
            fatalError("Unable to instantiate LocalVC")
        }
        
        let router = LocalScreenRouter(appComponent: appComponent, viewController: vc)
        let interactor = LocalScreenInteractor(presenter: vc, router: router)
        vc.interactor = interactor
        
        return NavigationController(rootViewController: vc)
    }
}

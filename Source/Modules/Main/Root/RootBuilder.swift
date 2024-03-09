//
//  RootBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

final class RootBuilder {
    func build(appComponent: AppComponent) -> LaunchRouting {
        guard let vc = UIStoryboard(name: "Root", bundle: .main).instantiateInitialViewController() as? RootViewController else {
            fatalError("Unable to instantiate RootVC")
        }
        
        let router = RootRouter(appComponent: appComponent, viewController: vc)
        let interactor = RootInteractor(presenter: vc, router: router)
        vc.interactor = interactor
        
        return router
    }
}

//
//  SplashBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

final class SplashBuilder {
    func build(appComponent: AppComponent, delegate: SplashDelegate) -> ViewController {
        guard let vc = UIStoryboard(name: "Splash", bundle: .main).instantiateInitialViewController() as? SplashViewController else {
            fatalError("Unable to instantiate SplacsVC")
        }
        
        let router = SplashRouter(appComponent: appComponent, viewController: vc)
        let interactor = SplashInteractor(presenter: vc, router: router, delegate: delegate)
        vc.interactor = interactor
        
        return vc
    }
}

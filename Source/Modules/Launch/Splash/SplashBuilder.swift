//
//  SplashBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

final class SplashBuilder {
    func build(appComponent: AppComponent, delegate: SplashDelegate) -> ViewController {
        guard let vc = UIStoryboard(name: "Splash", bundle: .main).instantiateInitialViewController() as? SplashViewController else {
            fatalError("Unable to instantiate SplacsVc")
        }
        
        let router = SplashRouter(appComponent: appComponent, viewController: vc)
        let interactor = SplashInteractor(presenter: vc, router: router, delegate: delegate)
        vc.interactor = interactor
        
        return vc
    }
}

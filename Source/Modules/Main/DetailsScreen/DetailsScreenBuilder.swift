//
//  DetailsScreenBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 10.03.24.
//

import UIKit

final class DetailsScreenBuilder {
    func build(appComponent: AppComponent, fileName: String, listener: MainScreenListener) -> ViewController {
        guard let vc = UIStoryboard(name: "DetailsScreen", bundle: .main).instantiateInitialViewController() as? DetailsScreenViewController else {
            fatalError("Unable to instantiate RootVC")
        }
        
        let router = DetailsScreenRouter(appComponent: appComponent, viewController: vc)
        let interactor = DetailsScreenInteractor(presenter: vc, router: router, fileName: fileName, listener: listener)
        vc.interactor = interactor
        
        return vc
    }
}

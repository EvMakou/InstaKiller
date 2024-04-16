//
//  DetailsScreenBuilder.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

final class DetailsScreenBuilder {
    func build(appComponent: AppComponent, imageIndex: Int) -> ViewController {
        guard let vc = UIStoryboard(name: "DetailsScreen", bundle: .main).instantiateInitialViewController() as? DetailsScreenViewController else {
            fatalError("Unable to instantiate DetailsVC")
        }
        
        let router = DetailsScreenRouter(appComponent: appComponent, viewController: vc)
        let interactor = DetailsScreenInteractor(presenter: vc, router: router, imageIndex: imageIndex)
        vc.interactor = interactor
        
        return vc
    }
}

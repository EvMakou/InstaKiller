//
//  SplashInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

protocol SplashDelegate: AnyObject {
    func splashDidAppear()
}

protocol SplashInteractable: ViewInteractable {
    var presenter: SplashPresentable { get }
    var router: SplashRouting { get }
}

final class SplashInteractor {
    unowned let presenter: SplashPresentable
    let router: SplashRouting

    weak var splashDelegate: SplashDelegate?
    
    init(presenter: SplashPresentable, router: SplashRouting, delegate: SplashDelegate?) {
        self.presenter = presenter
        self.router = router
        self.splashDelegate = delegate
    }
}

extension SplashInteractor: SplashInteractable {
    func viewDidAppear() {
        presenter.animateSplash { [weak self] in
            guard let self else {
                return
            }
            
            self.splashDelegate?.splashDidAppear()
        }
    }
}

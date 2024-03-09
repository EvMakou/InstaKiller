//
//  RootInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import Foundation

protocol RootInteractable: ViewInteractable {
    var presenter: RootPresentable { get }
    var router: RootRouting { get }
}

final class RootInteractor {
    unowned let presenter: RootPresentable
    let router: RootRouting

    init(presenter: RootPresentable, router: RootRouting) {
        self.presenter = presenter
        self.router = router
    }
}

extension RootInteractor: RootInteractable {
    func viewDidLoad() {
        router.routeToSplashScreen(delegate: self)
    }
}

extension RootInteractor: SplashDelegate {
    func splashDidAppear() {
        router.routeToMainScreen()
    }
}

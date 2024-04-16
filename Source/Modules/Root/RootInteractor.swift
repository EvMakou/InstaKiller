//
//  RootInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

protocol RootInteractable: ViewInteractable {
    var presenter: RootPresentable { get }
    var router: RootRouting { get }
}

final class RootInteractor {
    private let appConfig: AppConfig
    
    @Injected private var networkingService: NetworkingServiceProtocol
    @Injected private var apiService: APIServiceProtocol
    
    unowned let presenter: RootPresentable
    let router: RootRouting

    init(presenter: RootPresentable, router: RootRouting, appConfig: AppConfig) {
        self.presenter = presenter
        self.router = router
        self.appConfig = appConfig
    }
}

extension RootInteractor: RootInteractable {
    func viewDidLoad() {
        router.routeToSplashScreen(delegate: self)
        
        networkingService.prepare(appConfig: appConfig)
        apiService.prepare(appConfig: appConfig)
    }
}

extension RootInteractor: SplashDelegate {
    func splashDidAppear() {
        router.routeToMainScreen()
    }
}

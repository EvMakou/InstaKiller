//
//  MainScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import Foundation

protocol MainScreenInteractable: ViewInteractable {
    var presenter: MainScreenPresentable { get }
    var router: MainScreenRouting { get }
    
    func makePhotoAction()
}

final class MainScreenInteractor {
    unowned let presenter: MainScreenPresentable
    let router: MainScreenRouting

    init(presenter: MainScreenPresentable, router: MainScreenRouting) {
        self.presenter = presenter
        self.router = router
    }
}

extension MainScreenInteractor: MainScreenInteractable {
    func makePhotoAction() {
        presenter.makePhotoScreen()
    }
}

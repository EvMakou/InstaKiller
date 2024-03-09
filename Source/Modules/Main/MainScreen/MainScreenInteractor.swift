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
    func changeLayoutAction()
}

final class MainScreenInteractor {
    private var isColumnLayout = false
    
    unowned let presenter: MainScreenPresentable
    let router: MainScreenRouting

    init(presenter: MainScreenPresentable, router: MainScreenRouting) {
        self.presenter = presenter
        self.router = router
    }
}

extension MainScreenInteractor: MainScreenInteractable {
    func viewDidLoad() {
        presenter.adjustListLayout()
    }
    
    func makePhotoAction() {
        presenter.makePhotoScreen()
    }
    
    func changeLayoutAction() {
        isColumnLayout.toggle()
        
        if isColumnLayout {
            presenter.adjustColumnLayout()
        } else {
            presenter.adjustListLayout()
        }
    }
}

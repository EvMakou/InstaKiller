//
//  LocalScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 15.04.24.
//

import Foundation

protocol LocalScreenInteractable: ViewInteractable {
    var presenter: LocalScreenPresentable { get }
    var router: LocalScreenRouting { get }
}

final class LocalScreenInteractor {
    @Injected private var imagesService: ImagesServiceProtocol
    
    unowned let presenter: LocalScreenPresentable
    let router: LocalScreenRouting

    init(presenter: LocalScreenPresentable, router: LocalScreenRouting) {
        self.presenter = presenter
        self.router = router
    }
}

extension LocalScreenInteractor: LocalScreenInteractable {
    func viewDidLoad() {
        imagesService.startLoading()
        
        var viewModels: [IndexPath: DetailsViewModel] = [:]
        
        for (index, model) in imagesService.imageLocalCache().enumerated() {
            viewModels[IndexPath(row: index, section: 0)] = DetailsViewModel(model: model)
        }
        
        presenter.adjust(viewModels: viewModels)
    }
}

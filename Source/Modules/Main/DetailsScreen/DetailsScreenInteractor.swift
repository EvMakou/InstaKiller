//
//  DetailsScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 10.03.24.
//

import Foundation

protocol DetailsScreenInteractable: ViewInteractable {
    var presenter: DetailsScreenPresentable { get }
    var router: DetailsScreenRouting { get }
}

final class DetailsScreenInteractor {
    @Injected private var imagesStoreService: ImagesStoreServiceProtocol
    
    private var listener: MainScreenListener
    private let fileName: String
    
    unowned let presenter: DetailsScreenPresentable
    let router: DetailsScreenRouting

    init(presenter: DetailsScreenPresentable, router: DetailsScreenRouting, fileName: String, listener: MainScreenListener) {
        self.presenter = presenter
        self.router = router
        self.listener = listener
        self.fileName = fileName
    }
}

extension DetailsScreenInteractor: DetailsScreenInteractable {
    func viewDidLoad() {
        guard let image = imagesStoreService.image(fileName: fileName) else {
            return
        }
        
        presenter.adjust(viewModel: MainScreenViewModel(name: fileName, image: image))
    }
}

//
//  DetailsScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit.UIImage

protocol DetailsScreenInteractable: ViewInteractable {
    var presenter: DetailsScreenPresentable { get }
    var router: DetailsScreenRouting { get }
    
    func downloadImage(for indexPath: IndexPath)
    func likeDidSelect(indexPath: IndexPath, liked: Bool)
}

final class DetailsScreenInteractor {
    @Injected private var imagesService: ImagesServiceProtocol
    
    private var collectionViewRect: CGRect = .zero
    private let imageIndex: Int
    
    unowned let presenter: DetailsScreenPresentable
    let router: DetailsScreenRouting

    init(presenter: DetailsScreenPresentable, router: DetailsScreenRouting, imageIndex: Int) {
        self.presenter = presenter
        self.router = router
        self.imageIndex = imageIndex
    }
}

extension DetailsScreenInteractor: DetailsScreenInteractable {
    func viewDidLoad() {
        
        var viewModels: [IndexPath: DetailsViewModel?] = [:]
        
        for (index, model) in imagesService.photoModels.enumerated() {
            let dict: [IndexPath: DetailsViewModel?] = [IndexPath(row: index, section: 0): DetailsViewModel(model: model, image: nil)]
            dict.forEach { (k,v) in viewModels[k] = v }
        }
        
        presenter.adjust(viewModels: viewModels)
        
        imagesService.startLoading()
    }
    
    func viewDidLayoutSubviews() {
        guard collectionViewRect != presenter.collectionViewRect(), !presenter.collectionViewRect().isEmpty else {
            return
        }
        
        collectionViewRect = presenter.collectionViewRect()
        presenter.scrollTo(indexPath: IndexPath(row: imageIndex, section: 0))
    }
    
    func downloadImage(for indexPath: IndexPath) {
        guard let model = imagesService.photoModels[safe: indexPath.row] else {
            return
        }
        
        imagesService.image(for: indexPath.row) { [weak self] image in
            self?.presenter.updateCell(for: indexPath, with: DetailsViewModel(model: model, image: image))
        }
    }
    
    func likeDidSelect(indexPath: IndexPath, liked: Bool) {
        guard let model = imagesService.photoModels[safe: indexPath.row] else {
            return
        }
        
        imagesService.like(imageId: model.id, isLiked: !model.isLiked) { [weak self] items in
            items.forEach { self?.presenter.updateCell(for: IndexPath(row: $0.index, section: 0), with: DetailsViewModel(model: $0.model, image: $0.image)) }
        }
    }
}

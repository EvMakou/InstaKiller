//
//  MainScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit.UIImage

protocol MainScreenInteractable: ViewInteractable {
    var presenter: MainScreenPresentable { get }
    var router: MainScreenRouting { get }
    
    func makePhotoAction()
    func changeLayoutAction()
    func photoTaken(image: UIImage)
    func removePhoto(by index: Int)
    func didSelectItem(at indexPath: IndexPath)
}

protocol MainScreenListener: AnyObject {
    func titleDidChange()
}

final class MainScreenInteractor {
    @Injected private var imagesStoreService: ImagesStoreServiceProtocol
    
    private var isGridLayout = false
    private var imageNames: [String] = []
    
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
        
        let imageNames = imagesStoreService.imageNames()
        self.imageNames = imageNames
        
        presenter.update(viewModels: viewModels())
    }
    
    func makePhotoAction() {
        presenter.makePhotoScreen()
    }
    
    func changeLayoutAction() {
        isGridLayout.toggle()
        
        if isGridLayout {
            presenter.adjustGridLayout()
        } else {
            presenter.adjustListLayout()
        }
    }
    
    func photoTaken(image: UIImage) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let nameOfMonth = dateFormatter.string(from: now)
        
        //let currentIndex = Int(imagesStoreService.imageNames().last?.slice(from: "(", to: ")") ?? "0") ?? 0
        
        let currentIndex = Int(imagesStoreService.imageNames().last(where: { $0.contains("(") })?.slice(from: "(", to: ")") ?? "0") ?? 0
        
        let imageName: String = nameOfMonth + "(\(currentIndex + 1))"
        
        if imagesStoreService.saveImage(imageName: imageName, image: image) {
            imageNames.append(imageName)
            
            presenter.update(viewModels: viewModels())
        }
    }
    
    func removePhoto(by index: Int) {
        guard let nameToDelete = imageNames[safe: index] else {
            return
        }
        
        imageNames.remove(at: index)
        
        imagesStoreService.removeImageIfNeeded(fileName: nameToDelete)
        presenter.update(viewModels: viewModels())
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let fileName = imageNames[safe: indexPath.row] else {
            return
        }
        
        router.routeToDetailsScreen(fileName: fileName, listener: self)
    }
}

extension MainScreenInteractor: MainScreenListener {
    func titleDidChange() {
        imageNames = imagesStoreService.imageNames()
        presenter.update(viewModels: viewModels())
    }
}

private extension MainScreenInteractor {
    func viewModels() -> [MainScreenViewModel] {
        var viewModels: [MainScreenViewModel] = []
        for name in imageNames {
            if let image = imagesStoreService.image(fileName: name) {
                viewModels.append(MainScreenViewModel(name: name, image: image))
            }
        }
        
        return viewModels
    }
}

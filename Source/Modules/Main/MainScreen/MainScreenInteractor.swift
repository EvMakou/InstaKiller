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
}

final class MainScreenInteractor {
    @Injected private var imagesControlService: ImagesStoreServiceProtocol
    
    private var isColumnLayout = false
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
        
        let imageNames = imagesControlService.imageNames()
        self.imageNames = imageNames
        
        presenter.update(viewModels: viewModels())
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
    
    func photoTaken(image: UIImage) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let nameOfMonth = dateFormatter.string(from: now)
        
        let count = imagesControlService.imageNames().compactMap { $0.components(separatedBy: "(").first }.filter { $0 == nameOfMonth }.count
        
        let imageName = nameOfMonth + "(\(count + 1))"
        
        if imagesControlService.saveImage(imageName: imageName, image: image) {
            var viewModels = viewModels()
            viewModels.append(MainScreenViewModel(name: imageName, image: image))
            presenter.update(viewModels: viewModels)
        }
    }
    
    func viewModels() -> [MainScreenViewModel] {
        var viewModels: [MainScreenViewModel] = []
        for name in imageNames {
            if let image = imagesControlService.image(fileName: name) {
                viewModels.append(MainScreenViewModel(name: name, image: image))
            }
        }
        
        return viewModels
    }
}

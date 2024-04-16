//
//  MainScreenInteractor.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit.UIImage

protocol MainScreenInteractable: ViewInteractable {
    var presenter: MainScreenPresentable { get }
    var router: MainScreenRouting { get }
    
    func changeLayoutAction()
    func didSelectItem(at indexPath: IndexPath)
    func fetchData()
    func downloadImage(for indexPath: IndexPath)
    func didEndDisplay(indexPath: IndexPath)
    func codeFrom(url: URL?)
    func likesScreenDidSelect()
}

final class MainScreenInteractor {
    private struct Constants {
        static let perPage: Int = 30
    }
    
    @Injected private var apiService: APIServiceProtocol
    @Injected private var imagesService: ImagesServiceProtocol
    @Injected private var authorizationStoreService: AuthorizationStoreServiceProtocol
    
    private var isGridLayout = true
    private var currentPage = 0
    
    unowned let presenter: MainScreenPresentable
    let router: MainScreenRouting

    init(presenter: MainScreenPresentable, router: MainScreenRouting) {
        self.presenter = presenter
        self.router = router
    }
}

extension MainScreenInteractor: MainScreenInteractable {
    func viewDidLoad() {
        presenter.adjustGridLayout()
        
        guard authorizationStoreService.authorizationToken().isEmpty else {
            makeRequest()
            return
        }
        
        apiService.authorizeRequest { [weak self] (success, url) in
            if !success, let url {
                self?.presenter.showWebView(with: url)
            }
        }
    }
    
    func viewDidAppear() {
        
    }
    
    func changeLayoutAction() {
        isGridLayout.toggle()
        
        if isGridLayout {
            presenter.adjustGridLayout()
        } else {
            presenter.adjustListLayout()
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        router.routeToDetailsScreen(imageIndex: indexPath.row)
    }
    
    func fetchData() {
        makeRequest()
    }
    
    func downloadImage(for indexPath: IndexPath) {
        imagesService.image(for: indexPath.row) { [weak self] image in
            self?.presenter.updateCell(for: indexPath, with: image)
        }
    }
    
    func didEndDisplay(indexPath: IndexPath) {
        imagesService.cancel(index: indexPath.row)
    }
    
    func codeFrom(url: URL?) {
        guard let url else {
            return
        }
        
        let stringUrl = url.absoluteString
        if let range = stringUrl.range(of: "code=") {
            let code = stringUrl[range.upperBound...]
            apiService.logInRequest(code: String(code)) { [weak self] success in
                self?.presenter.hideWebView()
                self?.makeRequest()
            }
        }
    }
    
    func likesScreenDidSelect() {
        router.routeToLocalScreen()
    }
}

private extension MainScreenInteractor {
    func makeRequest() {
        imagesService.fetchImages(currentPage: currentPage, perPage: Constants.perPage) { [weak self] photos in
            guard let self else {
                return
            }
            
            DispatchQueue.main.async {
                self.currentPage += 1
            }
            
            var viewModels: [IndexPath: UIImage?] = [:]
            for (index, photo) in photos.enumerated() {
                if photo == nil {
                    let dict: [IndexPath: UIImage?] = [IndexPath(row: index, section: 0): nil]
                    dict.forEach { (k,v) in viewModels[k] = v }
                }
            }
            
            self.presenter.update(viewModels: viewModels)
        }
    }
}

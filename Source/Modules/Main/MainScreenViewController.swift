//
//  MainScreenViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit
import WebKit

protocol MainScreenControllable: ViewControllable {}

protocol MainScreenPresentable: UIViewController {
    var interactor: MainScreenInteractable? { get set }
    
    func adjustListLayout()
    func adjustGridLayout()
    func update(viewModels: [IndexPath: UIImage?])
    func updateCell(for indexPath: IndexPath, with image: UIImage?)
    func showWebView(with url: URL)
    func hideWebView()
}

final class MainScreenViewController: ViewController, MainScreenControllable {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout())
    private var webView: WKWebView?
    
    //private var cache = NSCache<AnyObject, UIImage>()
    private var viewModels: [IndexPath: UIImage?] = [:]
    
    var interactor: MainScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        interactor?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor?.viewDidAppear()
    }
    
    @objc
    private func changeLayoutAction() {
        interactor?.changeLayoutAction()
    }
    
    @objc
    private func likesScreenAction() {
        interactor?.likesScreenDidSelect()
    }
}

extension MainScreenViewController: MainScreenPresentable {
    func adjustListLayout() {
        collectionView.setCollectionViewLayout(listLayout(), animated: true)
    }
    
    func adjustGridLayout() {
        collectionView.setCollectionViewLayout(gridLayout(), animated: true)
    }
    
    func updateCell(for indexPath: IndexPath, with image: UIImage?) {
        viewModels[indexPath] = image
        collectionView.reloadItems(at: [indexPath])
    }
    
    func update(viewModels: [IndexPath: UIImage?]) {
        viewModels.forEach { (k,v) in self.viewModels[k] = v }
        collectionView.reloadData()
    }
    
    func showWebView(with url: URL) {
        let webView = createWebView()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
        self.webView = webView
    }
    
    func hideWebView() {
        UIView.animate(withDuration: 0.3) {
            self.webView?.alpha = 0.0
        } completion: { _ in
            self.webView?.removeFromSuperview()
            self.webView = nil
        }
    }
}

extension MainScreenViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        interactor?.codeFrom(url: navigationResponse.response.url)
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCell.identifier, for: indexPath) as? MainScreenCell else {
            return UICollectionViewCell()
        }
        
        cell.adjust(image: nil)
        cell.showActivityIndicator()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MainScreenCell else {
            return
        }
        
        if let image = viewModels[indexPath], image != nil {
            cell.adjust(image: image)
            cell.hideActivityIndicator()
        } else {
            interactor?.downloadImage(for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        interactor?.didEndDisplay(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.didSelectItem(at: indexPath)
    }
}

extension MainScreenViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let lastIndex = indexPaths.last?.item, lastIndex == viewModels.count - 1 else {
            return
        }
        
        interactor?.fetchData()
    }
}

private extension MainScreenViewController {
    func setupUI() {
        view.backgroundColor = .darkGray
        title = "Gallery"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(changeLayoutAction))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(likesScreenAction))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(MainScreenCell.self, forCellWithReuseIdentifier: MainScreenCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func createWebView() -> WKWebView {
        let webView = WKWebView()
        webView.frame = view.frame
        view.addSubview(webView)
        
        return webView
    }
    
    func listLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(280.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 8.0, trailing: 16.0)

            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: config)
        
        return layout
    }
    
    func gridLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.leading = 2.0
            item.contentInsets.trailing = 2.0
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 2.0, trailing: 16.0)

            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: config)
        
        return layout
    }
}

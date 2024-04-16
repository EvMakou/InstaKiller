//
//  DetailsScreenViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit
import WebKit

protocol DetailsScreenControllable: ViewControllable {}

protocol DetailsScreenPresentable: UIViewController {
    var interactor: DetailsScreenInteractable? { get set }
    
    func adjust(viewModels: [IndexPath: DetailsViewModel?])
    func scrollTo(indexPath: IndexPath)
    func updateCell(for indexPath: IndexPath, with viewModel: DetailsViewModel?)
    func collectionViewRect() -> CGRect
}

final class DetailsScreenViewController: ViewController, DetailsScreenControllable {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var viewModels: [IndexPath: DetailsViewModel?] = [:]
    
    private var webView: WKWebView?
    
    var interactor: DetailsScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        interactor?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor?.viewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        interactor?.viewDidLayoutSubviews()
    }
}

extension DetailsScreenViewController: DetailsScreenPresentable {
    func adjust(viewModels: [IndexPath: DetailsViewModel?]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
    
    func scrollTo(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func updateCell(for indexPath: IndexPath, with viewModel: DetailsViewModel?) {
        viewModels[indexPath] = viewModel
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionViewRect() -> CGRect {
        collectionView.frame
    }
}

extension DetailsScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell else {
            return UICollectionViewCell()
        }
        
        cell.adjust(viewModel: nil)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailsCell else {
            return
        }
        
        if let viewModel = viewModels[indexPath], viewModel?.image != nil {
            cell.adjust(viewModel: viewModel)
            cell.hideActivityIndicator()
        } else {
            interactor?.downloadImage(for: indexPath)
        }
    }
}

extension DetailsScreenViewController: DetailsCellDelegate {
    func likeDidSelect(in cell: DetailsCell, liked: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        interactor?.likeDidSelect(indexPath: indexPath, liked: liked)
    }
}

private extension DetailsScreenViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 8.0, trailing: 16.0)

            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: config)
        
        return layout
    }
}

//
//  LocalScreenViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 15.04.24.
//

import UIKit

protocol LocalScreenControllable: ViewControllable {}

protocol LocalScreenPresentable: UIViewController {
    var interactor: LocalScreenInteractable? { get set }
    
    func adjust(viewModels: [IndexPath: DetailsViewModel])
}

final class LocalScreenViewController: ViewController, LocalScreenControllable {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout())
    
    private var viewModels: [IndexPath: DetailsViewModel] = [:]
    
    var interactor: LocalScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        interactor?.viewDidLoad()
    }
}

extension LocalScreenViewController: LocalScreenPresentable {
    func adjust(viewModels: [IndexPath: DetailsViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
}

extension LocalScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell else {
            return UICollectionViewCell()
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailsCell, let viewModel = viewModels[indexPath] else {
            return
        }
        
        cell.adjust(viewModel: viewModel)
    }
}

private extension LocalScreenViewController {
    func setupUI() {
        title = "Local Storage"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
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

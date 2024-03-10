//
//  MainScreenViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

protocol MainScreenControllable: ViewControllable {}

protocol MainScreenPresentable: UIViewController {
    var interactor: MainScreenInteractable? { get set }
    
    func makePhotoScreen()
    func adjustListLayout()
    func adjustGridLayout()
    
    func update(viewModels: [MainScreenViewModel])
}

final class MainScreenViewController: ViewController, MainScreenControllable {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout())
    private var viewModels: [MainScreenViewModel] = []
    
    var interactor: MainScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.viewDidLoad()
    }
    
    @objc
    func makePhotoAction() {
        interactor?.makePhotoAction()
    }
    
    @objc
    func changeLayoutAction() {
        interactor?.changeLayoutAction()
    }
}

extension MainScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        print(image.size)
        interactor?.photoTaken(image: image)
    }
}

extension MainScreenViewController: MainScreenPresentable {
    func makePhotoScreen() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func adjustListLayout() {
        collectionView.setCollectionViewLayout(listLayout(), animated: true)
    }
    
    func adjustGridLayout() {
        collectionView.setCollectionViewLayout(gridLayout(), animated: true)
    }
    
    func update(viewModels: [MainScreenViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCell.identifier, for: indexPath) as? MainScreenCell,
              let viewModel = viewModels[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.adjust(viewModel: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"),
                                  identifier: nil,
                                  discoverabilityTitle: nil,
                                  attributes: .destructive,
                                  state: .off) { [weak self] ( _ ) in
                
                self?.interactor?.removePhoto(by: indexPath.row)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
        }
        
        return context
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.didSelectItem(at: indexPath)
    }
}

private extension MainScreenViewController {
    func setupUI() {
        view.backgroundColor = .darkGray
        title = "Main"
        
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationController?.toolbar.tintColor = .black
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.scrollEdgeAppearance = appearance
        
        var buttons = [UIBarButtonItem]()
        buttons.append( UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(makePhotoAction)) )
        buttons.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        buttons.append( UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeLayoutAction)) )

        toolbarItems = buttons

        navigationController?.setToolbarHidden(false, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainScreenCell.self, forCellWithReuseIdentifier: MainScreenCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func listLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140.0))
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

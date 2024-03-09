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
    func adjustColumnLayout()
    
    func update(images: [UIImage])
}

final class MainScreenViewController: ViewController, MainScreenControllable {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: columnLayout())
    private var images: [UIImage] = []
    
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
    
    func adjustColumnLayout() {
        collectionView.setCollectionViewLayout(columnLayout(), animated: true)
    }
    
    func update(images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCell.identifier, for: indexPath) as? MainScreenCell,
              let image = images[safe: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = image
        
        return cell
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
        buttons.append( UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil) )
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
    
    func columnLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, env) in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.leading = 1.0
            item.contentInsets.trailing = 1.0
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 16.0, bottom: 2.0, trailing: 16.0)

            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }, configuration: config)
        
        return layout
    }
}

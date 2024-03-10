//
//  DetailsScreenViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 10.03.24.
//

import UIKit

protocol DetailsScreenControllable: ViewControllable {}

protocol DetailsScreenPresentable: UIViewController {
    var interactor: DetailsScreenInteractable? { get set }
    
    func adjust(viewModel: MainScreenViewModel)
}

final class DetailsScreenViewController: ViewController, DetailsScreenControllable {
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    var interactor: DetailsScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.viewDidLoad()
    }
}

extension DetailsScreenViewController: DetailsScreenPresentable {
    func adjust(viewModel: MainScreenViewModel) {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.name
    }
}

private extension DetailsScreenViewController {
    func setupUI() {
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20.0)
            make.leading.trailing.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

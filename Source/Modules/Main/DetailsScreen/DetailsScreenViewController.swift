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
    func showAlert()
}

final class DetailsScreenViewController: ViewController, DetailsScreenControllable {
    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    var interactor: DetailsScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.viewDidLoad()
    }
    
    @objc
    func titleAction() {
        interactor?.titleDidSelect()
    }
}

extension DetailsScreenViewController: DetailsScreenPresentable {
    func adjust(viewModel: MainScreenViewModel) {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.name
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "Enter new title", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Confirm", style: .default) { [unowned ac] _ in
            guard let title = ac.textFields?[safe: 0]?.text else {
                return
            }
            
            self.titleLabel.text = title
            self.interactor?.didChange(title: title)
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
}

extension DetailsScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

private extension DetailsScreenViewController {
    func setupUI() {
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = true
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20.0)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleAction)))
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        
        scrollView.addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.width.height.equalToSuperview() }
    }
}

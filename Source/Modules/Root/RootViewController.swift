//
//  RootViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

protocol RootControllable: ViewControllable {}

protocol RootPresentable: UIViewController {
    var interactor: RootInteractable? { get set }
}

final class RootViewController: ViewController, RootControllable {
    var interactor: RootInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension RootViewController: RootPresentable { }

private extension RootViewController {
    func setupUI() {
        view.backgroundColor = .red
    }
}

//
//  SplashViewController.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

protocol SplashControllable: ViewControllable {}

protocol SplashPresentable: UIViewController {
    var interactor: SplashInteractable? { get set }
    
    func animateSplash(completion: @escaping () -> Void)
}

final class SplashViewController: ViewController, SplashControllable {
    var interactor: SplashInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.viewDidAppear()
    }
}

extension SplashViewController: SplashPresentable {
    func animateSplash(completion: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
    }
}

private extension SplashViewController {
    func setupUI() {}
}

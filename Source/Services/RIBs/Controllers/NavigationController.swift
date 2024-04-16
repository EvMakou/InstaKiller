//
//  NavigationController+ViewPresentable.swift
//  RIBsCore
//
//  Created by Yauheni Chumakou on 14/07/2023.
//

import UIKit

class NavigationController: UINavigationController {
    deinit {
        #if DEBUG
        debugPrint("Deinit - \(self)")
        #endif
    }
}


// MARK: - ViewControllable

extension NavigationController: ViewControllable {
    func push(viewController: ViewControllable, animated: Bool) {
        pushViewController(viewController, animated: animated)
    }
    
    func present(viewController: ViewControllable, animated: Bool) {
        present(viewController, animated: animated)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }
}

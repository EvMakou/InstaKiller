//
//  NavigationController+ViewPresentable.swift
//  RIBsCore
//
//  Created by Dmitry Savitskiy on 14/07/2022.
//

import UIKit

open class NavigationController: UINavigationController {
    deinit {
        #if DEBUG
        debugPrint("Deinit - \(self)")
        #endif
    }
}


// MARK: - ViewControllable

extension NavigationController: ViewControllable {
    public func push(viewController: ViewControllable, animated: Bool) {
        pushViewController(viewController, animated: animated)
    }
    
    public func present(viewController: ViewControllable, animated: Bool) {
        present(viewController, animated: animated)
    }
    
    public func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }
}

//
//  ViewControllable.swift
//  RIBsCore
//
//  Created by Dmitry Savitskiy on 14/07/2022.
//

import UIKit

public protocol ViewControllable: UIViewController {
    func push(viewController: ViewControllable, animated: Bool)
    func present(viewController: ViewControllable, animated: Bool)
    func dismissViewController(animated: Bool, completion: (() -> Void)?)

    func attachChild(viewController: UIViewController, destinationView: UIView)
    func attachChild(viewController: UIViewController)
    func detachChild(viewController: UIViewController)
}

//
//  UIViewController+Extensions.swift
//  RIBsCore
//
//  Created by Yauheni Chumakou on 23/10/23.
//

import UIKit.UIViewController
import SwiftUI
import SnapKit

extension UIViewController {
    func attachChild(viewController: UIViewController, destinationView: UIView) {
        addChild(viewController)
        destinationView.addSubview(viewController.view)
        viewController.view.frame = destinationView.bounds
        viewController.didMove(toParent: self)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        //viewController.view.anchor.top().left().right().bottom().apply()
        viewController.view.snp.makeConstraints { $0.edges.equalTo(destinationView) }
    }
    
    func attachChild(viewController: UIViewController) {
        attachChild(viewController: viewController, destinationView: view)
    }
    
    func detachChild(viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
    
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}

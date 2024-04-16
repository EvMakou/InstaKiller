//
//  ViewController+ViewPresentable.swift
//  RIBsCore
//
//  Created by Yauheni Chumakou on 14/07/2023.
//

import UIKit

class ViewController: UIViewController {
    deinit {
        #if DEBUG
        debugPrint("Deinit - \(self)")
        #endif
    }
}


// MARK: - Keyboard

extension ViewController {
    func subscribeForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func changeKeyboardHeight(_ height: CGFloat, willShow: Bool) {}
}


// MARK: - ViewControllable

extension ViewController: ViewControllable {
    func push(viewController: ViewControllable, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present(viewController: ViewControllable, animated: Bool) {
        present(viewController, animated: animated)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }
}


// MARK: - Private

private extension ViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        processKeyboardNotification(notification, keyboardWillShow: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        processKeyboardNotification(notification, keyboardWillShow: false)
    }
    
    func processKeyboardNotification(_ notification: NSNotification, keyboardWillShow: Bool) {
        // swiftlint:disable unused_optional_binding
        guard let _ = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let _ = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
              let targetFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        changeKeyboardHeight(targetFrame.height, willShow: keyboardWillShow)
    }
}

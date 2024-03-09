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
}

final class MainScreenViewController: ViewController, MainScreenControllable {
    var interactor: MainScreenInteractable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc
    func makePhotoAction() {
        interactor?.makePhotoAction()
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
        buttons.append( UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil) )

        self.toolbarItems = buttons

        
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

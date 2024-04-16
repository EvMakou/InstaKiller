//
//  Interactable.swift
//  RIBsCore
//
//  Created by Yauheni Chumakou on 14/07/2023.
//

import Foundation

protocol ViewInteractable {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewDidDisappear()
    func viewDidLayoutSubviews()
    func didReceiveMemoryWarning()
}

extension ViewInteractable {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewDidDisappear() {}
    func viewDidLayoutSubviews() {}
    func didReceiveMemoryWarning() {}
}

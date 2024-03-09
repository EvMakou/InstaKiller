//
//  Interactable.swift
//  RIBsCore
//
//  Created by Dmitry Savitskiy on 14/07/2022.
//

import Foundation

public protocol ViewInteractable {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewDidDisappear()
    func viewDidLayoutSubviews()
    func didReceiveMemoryWarning()
}

public extension ViewInteractable {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewDidDisappear() {}
    func viewDidLayoutSubviews() {}
    func didReceiveMemoryWarning() {}
}

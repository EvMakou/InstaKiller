//
//  ViewRouting.swift
//  RIBsCore
//
//  Created by Yauheni Chumakou on 14/07/2023.
//

import UIKit.UIWindow

protocol LaunchRouting: ViewRouting {
    func launchInWindow(_ window: UIWindow)
}

protocol ViewRouting {}

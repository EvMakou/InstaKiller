//
//  ViewRouting.swift
//  RIBsCore
//
//  Created by Dmitry Savitskiy on 14/07/2022.
//

import UIKit.UIWindow

public protocol LaunchRouting: ViewRouting {
    func launchInWindow(_ window: UIWindow)
}

public protocol ViewRouting {}

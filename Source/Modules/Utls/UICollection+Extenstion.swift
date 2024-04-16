//
//  UICollection+Extenstion.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

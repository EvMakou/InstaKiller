//
//  ServicesContainer.swift
//  CurrencyConverter
//
//  Created by Yauheni Chumakou on 20.01.23.
//

import Foundation

final class ServicesContainer {
    private var appDependencies = Dependencies.prepare()
    private lazy var imagesStoreService: ImagesStoreServiceProtocol = ImagesStoreService()
    
    init() {
        appDependencies.register({ [unowned self] in self.imagesStoreService })
    }
}

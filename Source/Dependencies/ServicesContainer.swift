//
//  ServicesContainer.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import Foundation

final class ServicesContainer {
    private var appDependencies = Dependencies.prepare()
    private lazy var networkingService: NetworkingServiceProtocol = NetworkingService()
    private lazy var apiService: APIServiceProtocol = APIService()
    private lazy var imagesService: ImagesServiceProtocol = ImagesService()
    private lazy var authorizationStoreService: AuthorizationStoreServiceProtocol = AuthorizationStoreService()
    
    init() {
        appDependencies.register({ [unowned self] in self.apiService })
        appDependencies.register({ [unowned self] in self.networkingService })
        appDependencies.register({ [unowned self] in self.imagesService })
        appDependencies.register({ [unowned self] in self.authorizationStoreService })
    }
}

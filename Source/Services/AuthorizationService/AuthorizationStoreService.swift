//
//  AuthorizationService.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 14.04.24.
//

import Foundation

protocol AuthorizationStoreServiceProtocol {
    func saveAuthorization(code: String)
    func authorizationCode() -> String
    
    func saveAuthorization(token: String)
    func authorizationToken() -> String
}

class AuthorizationStoreService {
    private struct Constants {
        static let authorizationCode = "authorizationCode"
        static let authorizationToken = "authorizationToken"
    }
}

extension AuthorizationStoreService: AuthorizationStoreServiceProtocol {
    func saveAuthorization(code: String) {
        UserDefaults.standard.setValue(code, forKey: Constants.authorizationCode)
    }
    
    func authorizationCode() -> String {
        UserDefaults.standard.string(forKey: Constants.authorizationCode) ?? ""
    }
    
    func saveAuthorization(token: String) {
        UserDefaults.standard.setValue(token, forKey: Constants.authorizationToken)
    }
    
    func authorizationToken() -> String {
        UserDefaults.standard.string(forKey: Constants.authorizationToken) ?? ""
    }
}

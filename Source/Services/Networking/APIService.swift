//
//  APIService.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit.UIImage

enum HttpMethod: String {
    case POST
    case GET
    case DELETE
}

protocol APIServiceProtocol {
    func prepare(appConfig: AppConfig)
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping ([Photo]) -> Void)
    func downloadImage(by url: URL, index: Int, completion: @escaping (UIImage?) -> Void)
    func cancel(index: Int)
    func authorizeRequest(completion: @escaping (Bool, URL?) -> Void)
    func logInRequest(code: String, completion: @escaping (Bool) -> Void)
    func like(imageId: String, isLiked: Bool, completion: @escaping (Bool) -> Void)
}

final class APIService {
    private struct Constants {
        static let photosPath = "/photos"
        static let authorizePath = "/oauth/authorize"
        static let tokenPath = "/oauth/token"
    }
    
    @Injected private var networkingService: NetworkingServiceProtocol
    @Injected private var authorizationStoreService: AuthorizationStoreServiceProtocol
    
    private var clientId = ""
    private var secretCode = ""
    private var redirectURI = ""
}

extension APIService: APIServiceProtocol {
    func prepare(appConfig: AppConfig) {
        self.clientId = appConfig.clientId
        self.secretCode = appConfig.secretCode
        self.redirectURI = appConfig.redirectURI
    }
    
    func like(imageId: String, isLiked: Bool, completion: @escaping (Bool) -> Void) {
        networkingService.makeRequest(path: "/photos/\(imageId)/like", params: [:], httpMethod: isLiked ? .POST : .DELETE) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func authorizeRequest(completion: @escaping (Bool, URL?) -> Void) {
        let params = ["redirect_uri": redirectURI, "response_type": "code", "scope": "public+read_user+write_user+write_likes", "client_id": clientId]
        networkingService.authorizeRequest(path: Constants.authorizePath, params: params) { success, url in
            completion(false, url)
        }
    }
    
    func logInRequest(code: String, completion: @escaping (Bool) -> Void) {
        let params = ["client_secret": secretCode, "redirect_uri": redirectURI, "code": code, "grant_type": "authorization_code", "client_id": clientId]
        
        networkingService.authorizeRequest(path: Constants.tokenPath, params: params) { [weak self] json, _ in
            if let token = json["access_token"] as? String, self?.authorizationStoreService.authorizationToken().isEmpty ?? false {
                self?.authorizationStoreService.saveAuthorization(token: token)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchPhotos(page: Int, perPage: Int, completion: @escaping ([Photo]) -> Void) {
        let params: [String: String] = ["page": "\(page)", "per_page": "\(perPage)"]
        networkingService.makeRequest(path: Constants.photosPath, params: params, httpMethod: .GET) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    let photos = try? JSONDecoder().decode([Photo].self, from: success)
                    completion(photos ?? [])
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func downloadImage(by url: URL, index: Int, completion: @escaping (UIImage?) -> Void) {
        networkingService.downloadImage(by: url, index: index) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func cancel(index: Int) {
        networkingService.cancel(index: index)
    }
}


//
//  NetworkingService.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit.UIImage

typealias ResultCompletion<T> = (Result<T, ResultError>) -> Void

enum ResultError: Error {
    case error
    case dataDoesntExist
    case dataIsWrong
}

struct Photo: Codable {
    let id: String
    let user: User
    let urls: Urls
    let description: String?
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case user
        case urls
        case description
        case isLiked = "liked_by_user"
    }
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
}

struct Urls: Codable {
    let regular: String
    let thumb: String
}

protocol NetworkingServiceProtocol {
    func makeRequest(path: String, params: [String: String], httpMethod: HttpMethod, completion: @escaping ResultCompletion<Data>)
    
    func prepare(appConfig: AppConfig)
    func downloadImage(by url: URL, index: Int, completion: @escaping ResultCompletion<UIImage?>)
    func cancel(index: Int)
    func authorizeRequest(path: String, params: [String: String], completion: @escaping ([String: Any], URL?) -> Void)
}

final class NetworkingService: NetworkingServiceProtocol {
    @Injected private var authorizationStoreService: AuthorizationStoreServiceProtocol
    
    private var dataTasks: [IndexPath: URLSessionDataTask] = [:]
    
    private var baseApiUrl = ""
    private var baseLoginWebUrl = ""
    
    func prepare(appConfig: AppConfig) {
        self.baseApiUrl = appConfig.baseApiUrl
        self.baseLoginWebUrl = appConfig.baseLoginWebUrl
    }
    
    func makeRequest(path: String, params: [String: String], httpMethod: HttpMethod, completion: @escaping ResultCompletion<Data>) {
        guard var urlComponents = URLComponents(string: baseApiUrl + path) else {
            return
        }
        
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("Bearer \(authorizationStoreService.authorizationToken())", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(.error))
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.error))
                }
                return
            }
            
            do {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        })
        
        task.resume()
    }
    
    func authorizeRequest(path: String, params: [String: String], completion: @escaping ([String: Any], URL?) -> Void) {
        guard var urlComponents = URLComponents(string: baseLoginWebUrl + path) else {
            return
        }
        
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion([:], nil)
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            guard let data else {
                DispatchQueue.main.async {
                    completion([:], nil)
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion([:], nil)
                }
                return
            }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                
                DispatchQueue.main.async {
                    completion(json ?? [:], url)
                }
            }
        })
        
        task.resume()
    }
    
    func downloadImage(by url: URL, index: Int, completion: @escaping ResultCompletion<UIImage?>) {
        let key = IndexPath(row: index, section: 0)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error as? NSError, error.code == NSURLErrorCancelled {
                DispatchQueue.main.async {
                    completion(.failure(.error))
                }
                return
            }
            
            guard let data else {
                completion(.failure(.dataDoesntExist))
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.dataIsWrong))
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.dataTasks[key] = nil
                completion(.success(image))
            }
        }
        
        task.resume()
        dataTasks[IndexPath(row: index, section: 0)] = task
    }
    
    func cancel(index: Int) {
        let key = IndexPath(row: index, section: 0)
        guard dataTasks[key] != nil else {
            return
        }
        
        dataTasks[key]?.cancel()
        dataTasks.removeValue(forKey: key)
    }
}

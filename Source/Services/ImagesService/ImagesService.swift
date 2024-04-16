//
//  ImagesService.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.04.24.
//

import UIKit.UIImage

protocol ImagesServiceProtocol {
    var photoModels: [Photo] { get }
    
    func image(for index: Int, completion: @escaping (UIImage?) -> Void)
    func fetchImages(currentPage: Int, perPage: Int, completion: @escaping ([UIImage?]) -> Void)
    func cancel(index: Int)
    
    func like(imageId: String, isLiked: Bool, completion: @escaping ([(index: Int, image: UIImage, model: Photo)]) -> Void)
    func startLoading()
    func imageLocalCache() -> [PhotoLocalModel]
}

final class ImagesService {
    private struct Constants {
        static let metadataSuffix: String = "_meta"
        static let folderName: String = "folderName"
    }
    
    @Injected private var apiService: APIServiceProtocol
    
    private var imagesCache: [UIImage?] = []
    private var localCache: [String: [PhotoLocalModel]] = [:]
    private let dateFormatter: DateFormatter = .init()
    
    var photoModels: [Photo] = []
}

extension ImagesService: ImagesServiceProtocol {
    func startLoading() {
        loadPhotos()
    }
    
    func imageLocalCache() -> [PhotoLocalModel] {
        Array(localCache[Constants.folderName] ?? [])
    }
    
    func image(for index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let rawUrl = photoModels[safe: index]?.urls.regular, let url = URL(string: rawUrl) else {
            completion(nil)
            return
        }
        
        
        apiService.downloadImage(by: url, index: index) { [weak self] image in
            self?.imagesCache[index] = image
            completion(image)
        }
    }
    
    func cancel(index: Int) {
        apiService.cancel(index: index)
    }
    
    func fetchImages(currentPage: Int, perPage: Int, completion: @escaping ([UIImage?]) -> Void) {
        apiService.fetchPhotos(page: currentPage, perPage: perPage) { [weak self] photos in
            photos.forEach { _ in self?.imagesCache.append(nil) }
            self?.photoModels.append(contentsOf: photos)
            completion(self?.imagesCache ?? [])
        }
    }
    
    func like(imageId: String, isLiked: Bool, completion: @escaping ([(index: Int, image: UIImage, model: Photo)]) -> Void) {
        apiService.like(imageId: imageId, isLiked: isLiked) { [weak self] success in
            guard let self else {
                completion([])
                return
            }
            
            if success {
                var items: [(index: Int, image: UIImage, model: Photo)] = []
                for (index, model) in self.photoModels.enumerated() {
                    if model.id == imageId {
                        let newModel = Photo(id: model.id, user: model.user, urls: model.urls, description: model.description, isLiked: isLiked)
                        self.photoModels[index] = newModel
                        
                        if let image = self.imagesCache[safe: index], let image {
                            items.append((index: index, image: image, model: newModel))
                        }
                    }
                }
                
                completion(items)
                return
            }
            completion([])
        }
        
        if isLiked {
            save(imageId: imageId)
        } else {
            deletePhoto(id: imageId)
        }
    }
}

private extension ImagesService {
    func loadPhotos() {
        guard let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.folderName) else {
            return
        }
        
        var path = folderURL.absoluteString
        
        if let range = folderURL.absoluteString.range(of: "file://") {
            path = String(folderURL.absoluteString[range.upperBound...])
        }
        
        guard let photoIDsItems = (try? FileManager.default.contentsOfDirectory(atPath: path))?.filter({ !$0.hasSuffix(Constants.metadataSuffix) }),
              !photoIDsItems.isEmpty else {
            return
        }
        
        let photoModels = photoIDsItems.compactMap { itemRawID -> PhotoLocalModel? in
            guard let metadata = loadMetadata(id: itemRawID, folderURL: folderURL) else {
                return nil
            }
            
            return PhotoLocalModel(id: itemRawID, folderURL: folderURL, metadata: metadata)
        }

        localCache[Constants.folderName] = photoModels
    }
    
    @discardableResult
    func save(imageId: String) -> PhotoLocalModel? {
        guard let index = photoModels.firstIndex(where: { $0.id == imageId }),
              let photoModel = photoModels[safe: index],
              let image = imagesCache[safe: index],
              let image else {
            return nil
        }
        
        let folderName = Constants.folderName
        
        if localCache[folderName] == nil {
            localCache[folderName] = []
        }
        
        guard let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Constants.folderName) else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: folderURL.absoluteString, isDirectory: nil) {
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        
        let model = PhotoLocalModel(id: imageId, folderURL: folderURL, title: photoModel.user.name, description: photoModel.description ?? "")
        saveMetadata(model)
        
        if let data = image.pngData() {
            try? data.write(to: model.fileURL)
            localCache[folderName]?.append(model)
        }
   
        return model
    }
    
    @discardableResult
    func deletePhoto(id: String) -> Bool {
        guard let photoToDelete = localCache.values.flatMap({ $0 }).first(where: { $0.id == id }) else {
            return false
        }
        
        if let index = localCache[Constants.folderName]?.firstIndex(where: { $0.id == photoToDelete.id }) {
            localCache[Constants.folderName]?.remove(at: index)
        }
        
        try? FileManager.default.removeItem(at: photoToDelete.fileURL)
        try? FileManager.default.removeItem(at: photoToDelete.folderURL.appendingPathExtension(photoToDelete.id + Constants.metadataSuffix))

        return true
    }
    
    func saveMetadata(_ model: PhotoLocalModel) {
        guard let data = try? JSONEncoder().encode(model.metadata) else {
            return
        }
        
        try? data.write(to: model.folderURL.appendingPathComponent(model.id + Constants.metadataSuffix))
    }
    
    func loadMetadata(id: String, folderURL: URL) -> PhotoMetadataModel? {
        guard let data = try? Data(contentsOf: folderURL.appendingPathComponent(id + Constants.metadataSuffix)) else {
            return nil
        }

        return try? JSONDecoder().decode(PhotoMetadataModel.self, from: data)
    }
}

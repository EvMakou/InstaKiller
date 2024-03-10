//
//  ImagesControlService.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

protocol ImagesStoreServiceProtocol {
    func saveImage(imageName: String, image: UIImage) -> Bool
    func image(fileName: String) -> UIImage?
    func imageNames() -> [String]
    
    @discardableResult
    func removeImageIfNeeded(fileName: String) -> Bool
    
    func change(fileName: String, to newFileName: String)
}

final class ImagesStoreService {
    private struct Constants {
        static let namesKey: String = "namesKey"
    }
}

extension ImagesStoreService: ImagesStoreServiceProtocol {
    func saveImage(imageName: String, image: UIImage) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        removeImageIfNeeded(fileName: imageName)
        
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            return false
        }

        do {
            try data.write(to: fileURL)
            
            var array = UserDefaults.standard.object(forKey: Constants.namesKey) as? [String] ?? []
            array.append(imageName)
            
            UserDefaults.standard.setValue(array, forKey: Constants.namesKey)
            
            return true
        } catch let error {
            fatalError("error saving file with error \(error)")
        }
    }
    
    @discardableResult
    func removeImageIfNeeded(fileName: String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                
                var array = UserDefaults.standard.object(forKey: Constants.namesKey) as? [String] ?? []
                if let index = array.firstIndex(of: fileName) {
                    array.remove(at: index)
                }
                
                UserDefaults.standard.setValue(array, forKey: Constants.namesKey)
                
                print("Removed old image")
                return true
            } catch let removeError {
                fatalError("couldn't remove file at path \(removeError)")
            }
        }
        
        return false
    }

    func image(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }
    
    func imageNames() -> [String] {
        UserDefaults.standard.object(forKey: Constants.namesKey) as? [String] ?? []
    }
    
    func change(fileName: String, to newFileName: String) {
        guard let image = image(fileName: fileName) else {
            return
        }
        
        removeImageIfNeeded(fileName: fileName)
        _ = saveImage(imageName: newFileName, image: image)
    }
}

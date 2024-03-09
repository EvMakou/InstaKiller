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

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { 
            return false
        }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                fatalError("couldn't remove file at path \(removeError)")
            }

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
}

//
//  DetailsViewModel.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 13.04.24.
//

import UIKit.UIImage

struct DetailsViewModel {
    let title: String?
    let description: String?
    let image: UIImage?
    let isLiked: Bool
    
    init(model: Photo, image: UIImage?) {
        self.title = model.user.name
        self.description = model.description
        self.image = image
        self.isLiked = model.isLiked
    }
    
    init(model: PhotoLocalModel) {
        self.title = model.metadata.title
        self.description = model.metadata.description
        self.isLiked = true
        
        if let data = try? Data(contentsOf: model.fileURL) {
            self.image = UIImage(data: data)
        } else {
            self.image = nil
        }
    }
}

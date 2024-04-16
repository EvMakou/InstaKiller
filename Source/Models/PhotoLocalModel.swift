//
//  PhotoLocalModel.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 15.04.24.
//

import Foundation

struct PhotoLocalModel {
    let id: String
    let metadata: PhotoMetadataModel
    let folderURL: URL
    var fileURL: URL {
        if #available(iOS 16.0, *) {
            folderURL.appending(path: id)
        } else {
            folderURL.appendingPathComponent(id)
        }
    }

    init(id: String, folderURL: URL, title: String, description: String) {
        self.id = id
        self.folderURL = folderURL
        self.metadata = .init(title: title, description: description)
    }
    
    init(id: String, folderURL: URL, metadata: PhotoMetadataModel) {
        self.id = id
        self.folderURL = folderURL
        self.metadata = metadata
    }
}

struct PhotoMetadataModel: Codable {
    let title: String
    let description: String
}

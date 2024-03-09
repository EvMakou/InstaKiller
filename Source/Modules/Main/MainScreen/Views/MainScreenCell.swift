//
//  MainScreenCell.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

final class MainScreenCell: UICollectionViewCell {
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleToFill
        addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .white
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

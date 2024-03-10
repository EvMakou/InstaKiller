//
//  MainScreenCell.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 9.03.24.
//

import UIKit

final class MainScreenCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .white
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        clipsToBounds = true
        layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjust(viewModel: MainScreenViewModel) {
        imageView.image = viewModel.image
        nameLabel.text = viewModel.name
    }
}

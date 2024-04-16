//
//  MainScreenCell.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 6.04.24.
//

import UIKit

final class MainScreenCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var image: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        clipsToBounds = true
        layer.cornerRadius = 10.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let image else {
            return
        }
        
        let imageSize = image.size
        let aspectRatio = imageSize.height / imageSize.width
        let maxSide = max(imageView.frame.width, imageView.frame.height)
        let size = CGSize(width: maxSide, height: maxSide * aspectRatio)
        
        guard imageView.image?.size != size else {
            return
        }

        if #available(iOS 15.0, *) {
            image.prepareThumbnail(of: size, completionHandler: { [weak self] preparedPreviewImage in
                DispatchQueue.main.async {
                    self?.imageView.image = preparedPreviewImage
                }
            })
        } else {
            imageView.image = image
        }
        
        self.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjust(image: UIImage?) {
        self.image = image
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

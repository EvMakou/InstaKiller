//
//  DetailsCell.swift
//  InstaKiller
//
//  Created by Yauheni Chumakou on 13.04.24.
//

import UIKit

protocol DetailsCellDelegate: AnyObject {
    func likeDidSelect(in cell: DetailsCell, liked: Bool)
}

final class DetailsCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let heartButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var viewModel: DetailsViewModel?
    
    weak var delegate: DetailsCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func heartButtonAction(_ sender: UIButton) {
        likeHandler()
    }
    
    @objc
    private func doubleTapAction(_ gesture: UITapGestureRecognizer) {
        likeHandler()
        
        let heart = createHeart()
        heart.transform = .init(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            heart.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.7) {
                heart.alpha = 0.0
            } completion: { _ in
                heart.removeFromSuperview()
            }
        }
    }
    
    func adjust(viewModel: DetailsViewModel?) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel?.title ?? ""
        descriptionLabel.text = viewModel?.description ?? ""
        imageView.image = viewModel?.image
        
        heartButton.isSelected = viewModel?.isLiked ?? false
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

private extension DetailsCell {
    func setupUI() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        titleLabel.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
        
        descriptionLabel.backgroundColor = .white
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { $0.bottom.leading.trailing.equalToSuperview() }
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        heartButton.addTarget(self, action: #selector(heartButtonAction), for: .touchUpInside)
        addSubview(heartButton)
        
        heartButton.snp.makeConstraints { $0.top.trailing.equalToSuperview() }
        
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        
        clipsToBounds = true
        layer.cornerRadius = 10.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    func createHeart() -> UIImageView {
        let width: CGFloat = 120.0
        let height: CGFloat = 100.0
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.frame = .init(x: frame.width / 2.0 - width / 2.0, y: frame.height / 2.0 - height / 2.0, width: width, height: height)
        addSubview(imageView)
        
        return imageView
    }
    
    func likeHandler() {
        guard let viewModel else {
            return
        }
        
        delegate?.likeDidSelect(in: self, liked: viewModel.isLiked)
    }
}

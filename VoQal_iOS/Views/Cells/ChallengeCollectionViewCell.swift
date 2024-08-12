//
//  ChallengeCollectionViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/10/24.
//

import UIKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "challengeCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.layer.cornerCurve = .continuous
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "challengeEx1")
        
        return imageView
    }()
    
    private let songLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Medium", size: 23)
        label.text = "봄이 좋냐 - 10cm cover"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Medium", size: 17)
        label.textColor = .white
        label.text = "송눈섭"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainBackgroundColor")
        addSubViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(songLabel)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(likeButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 4.0/3.0),
            
            likeButton.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 25),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            songLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            songLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 5),
            songLabel.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -5),
            songLabel.heightAnchor.constraint(equalToConstant: 25),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: songLabel.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 10),
            nicknameLabel.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -5),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    func configure() {
        
    }
    
}

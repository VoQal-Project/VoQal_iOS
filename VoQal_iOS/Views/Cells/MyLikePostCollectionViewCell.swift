//
//  MyLikePostCollectionViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/31/24.
//

import UIKit
import AVFoundation

class MyLikePostCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "myLikePostCollectionViewCell"
    internal var liked: Bool = true
    internal var player: AVPlayer?
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.layer.cornerCurve = .continuous
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "challengeEx1")
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    internal let coverImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isHidden = true
        
        return view
    }()
    
    internal let likeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hexCode: "FF3B30", alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainBackgroundColor")
        addSubViews()
        setConstraints()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(coverImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(songLabel)
        contentView.addSubview(nicknameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 4.0/3.0),
            
            coverImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            songLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            songLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: 5),
            songLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            songLabel.heightAnchor.constraint(equalToConstant: 25),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: songLabel.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 10),
            nicknameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePlayPause))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    func configure(_ songTitle: String, _ singer: String, _ nickname: String) {
        
        self.songLabel.text = "\(songTitle) - \(singer) cover"
        self.nicknameLabel.text = nickname
        
    }
    
    func updateThumbnail(_ thumbnail: UIImage?) {
        self.thumbnailImageView.image = thumbnail
        print(thumbnail)
    }
    
    func updatePlayer(_ player: AVPlayer?) {
        self.player = player
        print("player: \(player)")
        
        configureAudioSession()
    }
    
    @objc func togglePlayPause() {
        guard let player = player else { return }
        
        if player.timeControlStatus == .playing {
            coverImageView.isHidden = false
            player.pause()
        } else {
            coverImageView.isHidden = true
            player.play()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        player?.pause()
        player = nil
        coverImageView.isHidden = true
    }
    
    func updateLikeBtn(_ liked: Bool) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        
        if liked {
            self.likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }
    
}

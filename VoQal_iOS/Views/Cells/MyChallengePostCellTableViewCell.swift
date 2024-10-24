//
//  MyChallengePostCellTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/23/24.
//

import UIKit
import AVFoundation

class MyChallengePostCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    static let identifier: String = "MyChallengePostCell"
    internal var player: AVPlayer?
    
    private let menuButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 23)
        let image = UIImage(systemName: "ellipsis", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return view
    }()
    
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
    
    internal let likeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hexCode: "FF3B30", alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func addSubViews() {
        contentView.addSubview(menuButton)
        contentView.addSubview(bodyView)
        bodyView.addSubview(thumbnailImageView)
        bodyView.addSubview(coverImageView)
        bodyView.addSubview(songLabel)
        bodyView.addSubview(nicknameLabel)
        bodyView.addSubview(likeButton)
        bodyView.addSubview(likeCountLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            menuButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            menuButton.heightAnchor.constraint(equalToConstant: 25),
            menuButton.widthAnchor.constraint(equalToConstant: 25),
            
            bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 10),
            bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: bodyView.topAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, multiplier: 4.0/3.0),
            
            coverImageView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 15),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            likeCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 5),
            likeCountLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 50),
            
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
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePlayPause))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        bodyView.addGestureRecognizer(tapGesture)
    }
    
    func configure(_ likeCount: Int, _ songTitle: String, _ singer: String, _ nickname: String) {
        
        updateLikeCount(likeCount)
        
        self.songLabel.text = "\(songTitle) - \(singer) cover"
        self.nicknameLabel.text = nickname
        
    }
    
    func updateThumbnail(_ thumbnail: UIImage?) {
        DispatchQueue.main.async {
            self.thumbnailImageView.image = thumbnail
            print(thumbnail)
        }
    }
    
    func updatePlayer(_ player: AVPlayer?) {
        self.player = player
        print(player)
        
        configureAudioSession()
    }
    
    func updateLikeCount(_ likeCount: Int) {
        likeCountLabel.text = String(likeCount)
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == likeButton {
            return false
        }
        return true
    }
    
    func setMenuButton(_ firstItem: UIAction, _ secondItem: UIAction) {
        let menu = UIMenu(title: "", children: [firstItem, secondItem])
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
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

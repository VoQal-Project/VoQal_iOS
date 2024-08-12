//
//  RecordFileDetailView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/8/24.
//

import UIKit

class RecordFileDetailView: BaseView {
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hexCode: "6e6e6e", alpha: 1.0)
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image = UIImage(systemName: "music.note", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor(hexCode: "939393", alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var recordTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Medium", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let audioProgressView: CustomProgressView = {
        let progressView = CustomProgressView()
        progressView.progress = 0.0
        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor(hexCode: "D9D9D9", alpha: 0.7)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    internal let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let volumeProgressView: CustomProgressView = {
        let progressView = CustomProgressView()
        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor(hexCode: "D9D9D9", alpha: 0.7)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    private let minVolumeIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        let image = UIImage(systemName: "speaker.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let maxVolumeIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        let image = UIImage(systemName: "speaker.wave.3.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(albumCoverImageView)
        addSubview(recordTitleLabel)
        addSubview(audioProgressView)
        addSubview(playPauseButton)
        addSubview(volumeProgressView)
        addSubview(minVolumeIcon)
        addSubview(maxVolumeIcon)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            albumCoverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumCoverImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: 200),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: 200),
            
            recordTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordTitleLabel.topAnchor.constraint(equalTo: albumCoverImageView.bottomAnchor, constant: 25),
            
            audioProgressView.topAnchor.constraint(equalTo: recordTitleLabel.bottomAnchor, constant: 30),
            audioProgressView.heightAnchor.constraint(equalToConstant: 5),
            audioProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            audioProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: audioProgressView.bottomAnchor, constant: 30),
            playPauseButton.widthAnchor.constraint(equalToConstant: 55),
            playPauseButton.heightAnchor.constraint(equalToConstant: 55),
            
            volumeProgressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            volumeProgressView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 50),
            volumeProgressView.widthAnchor.constraint(equalToConstant: 220),
            volumeProgressView.heightAnchor.constraint(equalToConstant: 5),
            
            minVolumeIcon.trailingAnchor.constraint(equalTo: volumeProgressView.leadingAnchor, constant: -10),
            minVolumeIcon.centerYAnchor.constraint(equalTo: volumeProgressView.centerYAnchor),
            minVolumeIcon.widthAnchor.constraint(equalToConstant: 20),
            minVolumeIcon.heightAnchor.constraint(equalToConstant: 20),
            
            maxVolumeIcon.leadingAnchor.constraint(equalTo: volumeProgressView.trailingAnchor, constant: 10),
            maxVolumeIcon.centerYAnchor.constraint(equalTo: volumeProgressView.centerYAnchor),
            maxVolumeIcon.widthAnchor.constraint(equalToConstant: 20),
            maxVolumeIcon.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    func configure(_ recordTitle: String) {
        self.recordTitleLabel.text = "\(recordTitle)"
    }
    
}

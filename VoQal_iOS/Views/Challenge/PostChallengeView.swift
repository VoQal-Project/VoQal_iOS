//
//  PostChallengeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit

class PostChallengeView: BaseView {

    private let dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.7
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10.0
        view.layer.cornerCurve = .continuous
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return view
    }()
    
    internal let closeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 17)
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.layer.cornerRadius = 10.0
        button.layer.cornerCurve = .continuous
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let recordFileField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5.0
        textField.layer.cornerCurve = .continuous
        textField.layer.borderColor = UIColor(hexCode: "474747", alpha: 1.0).cgColor
        textField.layer.borderWidth = 2.0
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    internal let uploadRecordFileButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let uploadThumbnailButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 32)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let ThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        
        return imageView
    }()
    
    private let songTitleField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "제목을 입력해주세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let artistField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "가수명을 입력해주세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(dimmedView)
        addSubview(contentView)
        addSubview(closeButton)
        contentView.addSubview(recordFileField)
        contentView.addSubview(uploadRecordFileButton)
        contentView.addSubview(uploadThumbnailButton)
        contentView.addSubview(ThumbnailImageView)
        contentView.addSubview(songTitleField)
        contentView.addSubview(artistField)
        contentView.addSubview(separatorLine)
        contentView.addSubview(postButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -85),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            
            recordFileField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            recordFileField.heightAnchor.constraint(equalToConstant: 40),
            recordFileField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 35),
            recordFileField.trailingAnchor.constraint(equalTo: uploadRecordFileButton.leadingAnchor, constant: -15),
            
            uploadRecordFileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uploadRecordFileButton.centerYAnchor.constraint(equalTo: recordFileField.centerYAnchor),
            uploadRecordFileButton.widthAnchor.constraint(equalToConstant: 30),
            uploadRecordFileButton.heightAnchor.constraint(equalToConstant: 30),
            
            uploadThumbnailButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            uploadThumbnailButton.topAnchor.constraint(equalTo: recordFileField.bottomAnchor, constant: 50),
            uploadThumbnailButton.widthAnchor.constraint(equalToConstant: 115),
            uploadThumbnailButton.heightAnchor.constraint(equalToConstant: 115),
            
            ThumbnailImageView.topAnchor.constraint(equalTo: recordFileField.bottomAnchor, constant: 15),
            ThumbnailImageView.bottomAnchor.constraint(equalTo: songTitleField.topAnchor, constant: -15),
            ThumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ThumbnailImageView.widthAnchor.constraint(equalTo: ThumbnailImageView.heightAnchor, multiplier: 3.0/4.0),
            
            songTitleField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            songTitleField.topAnchor.constraint(equalTo: uploadThumbnailButton.bottomAnchor, constant: 55),
            songTitleField.heightAnchor.constraint(equalToConstant: 40),
            songTitleField.widthAnchor.constraint(equalToConstant: 260),
            
            artistField.leadingAnchor.constraint(equalTo: songTitleField.leadingAnchor),
            artistField.trailingAnchor.constraint(equalTo: songTitleField.trailingAnchor),
            artistField.heightAnchor.constraint(equalToConstant: 40),
            artistField.topAnchor.constraint(equalTo: songTitleField.bottomAnchor, constant: 20),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorLine.topAnchor.constraint(equalTo: artistField.bottomAnchor, constant: 45),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 120),
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            postButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    func getSongTitleValue() -> String? {
        return songTitleField.text
    }
    
    func getArtistValue() -> String? {
        return artistField.text
    }

    func setupThumbnailImageView(_ image: UIImage) {
        self.ThumbnailImageView.image = image
        self.ThumbnailImageView.isHidden = false
    }
    
}

//
//  ChallengeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit
import JJFloatingActionButton

class ChallengeView: BaseView {
    
    weak var challengeViewController: ChallengeViewController?
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "오늘의 키워드는 봄입니다."
        label.font = UIFont(name: "SUIT-Medium", size: 23)
        
        return label
    }()

    internal let collectionView: UICollectionView = {
        // 먼저 레이아웃을 생성
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0

        // UICollectionView를 레이아웃과 함께 초기화
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "mainBackgroundColor")
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let floatingButton: JJFloatingActionButton = {
        let button = JJFloatingActionButton()
        button.buttonColor = UIColor(hexCode: "474747", alpha: 1.0)
        button.itemSizeRatio = 0.80
        button.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureFloatingButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(keywordLabel)
        addSubview(collectionView)
        addSubview(floatingButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            keywordLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            keywordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            collectionView.topAnchor.constraint(equalTo: keywordLabel.bottomAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            floatingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    func setupKeywordLabel(with keyword: String, keywordColor: UIColor) {
        let fullText = "오늘의 키워드는 \(keyword)입니다."
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // 키워드의 범위를 찾아서 색상을 적용
        if let keywordRange = fullText.range(of: keyword) {
            let nsRange = NSRange(keywordRange, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: keywordColor, range: nsRange)
        }
        
        keywordLabel.attributedText = attributedText
    }
    
    private func setupCollectionView() {
        
    }
    
    private func configureFloatingButton() {
        let firstItem = floatingButton.addItem()
        firstItem.imageView.image = UIImage(systemName: "pencil")
        firstItem.buttonColor = UIColor(hexCode: "FFFAFA", alpha: 1.0)
        firstItem.buttonImageColor = UIColor(named: "mainButtonColor")!
        firstItem.imageSize = CGSize(width: 30, height: 30)
        firstItem.action = { [weak self] item in
            self?.challengeViewController?.didTapPostChallengeBtn()
//            self?.challengeViewController?.temporarilyStopOrPlayPlayers(true)
        }
        
        let secondItem = floatingButton.addItem()
        secondItem.imageView.image = UIImage(systemName: "person.fill")
        secondItem.buttonColor = UIColor(hexCode: "FFFAFA", alpha: 1.0)
        secondItem.buttonImageColor = UIColor(named: "mainButtonColor")!
        secondItem.imageSize = CGSize(width: 30, height: 30)
        secondItem.action = { [weak self] item in
            self?.challengeViewController?.didTapMyPostBtn()
//            self?.challengeViewController?.temporarilyStopOrPlayPlayers(true)
        }
        
        let thirdItem = floatingButton.addItem()
        thirdItem.imageView.image = UIImage(systemName: "heart.fill")
        thirdItem.buttonColor = UIColor(hexCode: "FFFAFA", alpha: 1.0)
        thirdItem.buttonImageColor = UIColor(named: "mainButtonColor")!
        thirdItem.imageSize = CGSize(width: 30, height: 30)
        thirdItem.action = { [weak self] item in
            self?.challengeViewController?.didTapMyLikePostBtn()
//            self?.challengeViewController?.temporarilyStopOrPlayPlayers(true)
        }
    }
    
}



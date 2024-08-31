//
//  MyChallengePostView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit

class MyChallengePostView: BaseView {

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        super.addSubViews()
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }

}

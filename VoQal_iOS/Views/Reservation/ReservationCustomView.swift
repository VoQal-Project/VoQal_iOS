//
//  ReservationCustomView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/18/24.
//

import UIKit

class ReservationCustomView: BaseView {

    internal let roomCollectionButton: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 10.0
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = UIColor(named: "mainBackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    private let roomCustomLabel: UILabel = {
        let label = UILabel()
        label.text = "방 번호를 선택해주세요"
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let fetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("조회하기", for: .normal)
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10.0
        
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    internal let timeCollectionButton: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 10.0
        collectionView.backgroundColor = UIColor(named: "mainBackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    internal let timeCustomLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 시간을 선택해주세요"
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        setConstraints()
        
        timeCustomLabel.isHidden = true
        timeCollectionButton.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        addSubview(roomCollectionButton)
        addSubview(roomCustomLabel)
        addSubview(fetchButton)
        addSubview(separatorLine)
        addSubview(timeCollectionButton)
        addSubview(timeCustomLabel)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            roomCustomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            roomCustomLabel.topAnchor.constraint(equalTo: topAnchor),
            
            roomCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            roomCollectionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            roomCollectionButton.topAnchor.constraint(equalTo: roomCustomLabel.bottomAnchor, constant: 10),
            roomCollectionButton.heightAnchor.constraint(equalToConstant: 40),
            
            fetchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: roomCollectionButton.bottomAnchor, constant: 25),
            fetchButton.widthAnchor.constraint(equalToConstant: 85),
            fetchButton.heightAnchor.constraint(equalToConstant: 35),
            
            separatorLine.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 30),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            timeCustomLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 30),
            timeCustomLabel.leadingAnchor.constraint(equalTo: roomCustomLabel.leadingAnchor),
            
            timeCollectionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeCollectionButton.topAnchor.constraint(equalTo: timeCustomLabel.bottomAnchor, constant: 10),
            timeCollectionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeCollectionButton.heightAnchor.constraint(equalTo: roomCollectionButton.heightAnchor),
            timeCollectionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}


//
//  ReadReceiptCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 10/30/24.
//

import UIKit

class ReadReceiptCell: UITableViewCell {
    static let identifier = "ReadReceiptCell"
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "여기까지 읽었습니다"
        label.textColor = UIColor(named: "mainBackgroundColor")
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        // 레이블의 백그라운드 뷰
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBackground
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundView)
        
        contentView.addSubview(separatorLine)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            // 구분선
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // 레이블
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // 백그라운드 뷰 (레이블 주변 패딩)
            backgroundView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            backgroundView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            backgroundView.topAnchor.constraint(equalTo: label.topAnchor, constant: -2),
            backgroundView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 2)
        ])
        
        // 레이블을 백그라운드 뷰 위로 가져오기
        contentView.bringSubviewToFront(label)
    }
}

//
//  CustomCollectionViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/18/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let contentLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    static let identifier: String = "reservationCustomCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "181818")
        addSubViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(separator)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    internal func configure(_ text: String, _ isLast: Bool) {
        contentLabel.text = text
        separator.isHidden = isLast
    }
    
    internal func configureAvailableTime(_ isAvailable: Bool) {
        contentLabel.textColor = isAvailable ? .white : .gray
    }
}

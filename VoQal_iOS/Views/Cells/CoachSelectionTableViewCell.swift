//
//  CoachSelectionTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/11/24.
//

import UIKit

class CoachSelectionTableViewCell: UITableViewCell {

    static let identifier: String = "CoachTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        imageView.image = UIImage(systemName: "person.fill", withConfiguration: configuration)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CoachSelectionTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16.0, left: 0, bottom: 16, right: 0))
        contentView.layer.cornerRadius = 15.0
        contentView.backgroundColor = UIColor(named: "bottomBarColor")
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    func configure(with name: String) {
        let fullName = "\(name) 코치님"
        let attributedText = NSMutableAttributedString(string: fullName, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23), NSAttributedString.Key.kern: 1.5])
        
        // "코치님" 부분의 범위를 찾아서 작은 글씨로 설정
        let coachRange = (fullName as NSString).range(of: "코치님")
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], range: coachRange)
        
        nameLabel.attributedText = attributedText
    }
    
    private func addSubViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
//            iconImageView.widthAnchor.constraint(equalToConstant: 40),
//            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

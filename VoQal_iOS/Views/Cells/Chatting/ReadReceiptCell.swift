//
//  ReadReceiptCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 10/30/24.
//

import UIKit

class ReadReceiptCell: UITableViewCell {
    static let identifier = "ReadReceiptCell"

    private let label: UILabel = {
        let label = UILabel()
        label.text = "여기까지 읽었습니다."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ReservationManageTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/21/24.
//

import UIKit

protocol MyReservationTableViewCellDelegate: AnyObject {
    func didTapEditButton(_ cell: MyReservationTableViewCell)
    func didTapDeleteButton(_ cell: MyReservationTableViewCell)
}

class MyReservationTableViewCell: UITableViewCell {
    
    static let identifier = "myReservationCell"
    weak var delegate: MyReservationTableViewCellDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bottomBarColor")
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let roomAndTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    internal let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
//        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RequestListTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(roomAndTimeLabel)
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            
            roomAndTimeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            roomAndTimeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            buttonStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
        ])
    }
    
    private func setAddTarget() {
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            dateLabel.text = nil
            roomAndTimeLabel.text = nil
        }

    func configure(_ date: String, _ roomId: Int, _ time: String) {
        print("date: \(date), roomIdLabel: \(roomId), time: \(time)")
        dateLabel.text = date
        roomAndTimeLabel.text = String(roomId) + "번 방  -  " + time
    }
    
    @objc private func didTapEditButton(_ cell: UITableViewCell) {
        delegate?.didTapEditButton(self)
    }
    
    @objc private func didTapDeleteButton(_ cell: UITableViewCell) {
        delegate?.didTapDeleteButton(self)
    }
    
}

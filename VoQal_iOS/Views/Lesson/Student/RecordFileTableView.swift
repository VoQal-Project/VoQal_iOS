//
//  RecordFileTableView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import UIKit

class RecordFileTableView: BaseView {

    internal let tableView: UITableView = {
        let tableView = UITableView()
//        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(tableView)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}

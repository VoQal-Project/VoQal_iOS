//
//  RequestListView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class RequestListView: BaseView {

    internal let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(tableView)
    }
    
    override func setConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5),
        ])
    }
    
}

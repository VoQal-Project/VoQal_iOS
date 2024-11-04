//
//  RecordFileListView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import UIKit
import JJFloatingActionButton

class RecordFileListView: BaseView {
    
    internal let floatingButton: JJFloatingActionButton = {
        let button = JJFloatingActionButton()
        button.buttonColor = UIColor(hexCode: "474747", alpha: 1.0)
        button.itemSizeRatio = 0.80
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
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
        addSubview(floatingButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            floatingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            floatingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

}

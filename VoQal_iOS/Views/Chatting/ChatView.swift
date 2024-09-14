//
//  ChatView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit

class ChatView: BaseView {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func addSubViews() {
        
    }
    
    override func setConstraints() {
        
    }
    
}

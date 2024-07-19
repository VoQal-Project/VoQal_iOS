//
//  RequestListViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class RequestListViewController: BaseViewController {

    private let requestListView = RequestListView()
    private let requestListManager = RequestListManager()
    private var students: [Student] = []
    
    override func loadView() {
        view = requestListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        getStudentsList()
        
        requestListView.tableView.register(RequestListTableViewCell.self, forCellReuseIdentifier: RequestListTableViewCell.identifier)
        
        requestListView.tableView.delegate = self
        requestListView.tableView.dataSource = self

    }
    
    private func getStudentsList() {
        requestListManager.getRequestStudentList { model in
            if let model = model {
                if model.status == 200 {
                    self.students = model.students
                    DispatchQueue.main.async {
                        self.requestListView.tableView.reloadData()
                    }
                }
                else {
                    print("Error \(model.status). 학생 리스트를 불러오지 못했습니다.")
                }
            }
            else {
                print("model을 받아오지 못했습니다.")
            }
        }
    }
}

extension RequestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestListTableViewCell.identifier, for: indexPath) as? RequestListTableViewCell else {
            return UITableViewCell()
        }
        
        if let name = students[indexPath.row].studentName {
            cell.configure(name: name)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    
}

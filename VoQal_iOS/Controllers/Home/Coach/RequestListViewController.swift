//
//  RequestListViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class RequestListViewController: BaseViewController, RequestListTableViewCellDelegate {

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
    
    func didTapApproveButton(in cell: RequestListTableViewCell) {
        if let indexPath = requestListView.tableView.indexPath(for: cell) {
            guard let studentId = students[indexPath.row].studentId else {
                print("학생 정보를 찾지 못했습니다.")
                return
            }
            requestListManager.approveStudent(studentId) { model in
                guard let model = model else {
                    print("학생 승인 모델을 받아오는 데에 실패했습니다.")
                    return
                }
                if model.status == 200 {
                    let alert = UIAlertController(title: "승인 완료", message: "해당 학생을 성공적으로 승인하였습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.getStudentsList()
                        self.requestListView.tableView.reloadData()
                    }))
                    self.present(alert, animated: true)
                }
                else {
                    print("학생 승인 요청 실패")
                }
            }
        } else {
            print("셀을 찾지 못했습니다.")
        }
    }
    
    func didTapRejectButton(in cell: RequestListTableViewCell) {
        if let indexPath = requestListView.tableView.indexPath(for: cell) {
            guard let studentId = students[indexPath.row].studentId else {
                print("학생 정보를 찾지 못했습니다.")
                return
            }
            requestListManager.rejectStudent(studentId) { model in
                guard let model = model else {
                    print("학생 거절 모델을 받아오는 데에 실패했습니다.")
                    return
                }
                if model.status == 200 {
                    self.getStudentsList()
                    self.requestListView.tableView.reloadData()
                }
                else {
                    print("학생 거절 요청 실패")
                }
            }
        } else {
            print("셀을 찾지 못했습니다.")
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
        
        cell.delegate = self
        print("Cell delegate set for row \(indexPath.row)")  // 디버깅 메시지 추가
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

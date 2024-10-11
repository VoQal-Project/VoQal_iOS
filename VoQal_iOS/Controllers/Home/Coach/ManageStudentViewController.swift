//
//  ManageStudentViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class ManageStudentViewController: BaseViewController {

    private let manageStudentView = ManageStudentView()
    private let manageStudentManager = ManageStudentManager()
    private let setLessonSongManager = SetLessonSongManager()
    internal var students: [ApprovedStudent] = [] {
        didSet {
            manageStudentView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = manageStudentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        manageStudentView.tableView.dataSource = self
        manageStudentView.tableView.delegate = self
        manageStudentView.tableView.register(StudentsTableViewCell.self, forCellReuseIdentifier: StudentsTableViewCell.identifier)
        
        fetchStudents()
    }
    
    override func setAddTarget() {
        
    }
    
    override func setupNavigationBar() {
        
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "equal")?.withTintColor(.white), style: .done, target: self, action: #selector(didTapRequestListButton))
        
        self.navigationItem.rightBarButtonItem = navigationButton
        
        self.navigationItem.backButtonTitle = ""
        
    }
    
    @objc private func didTapRequestListButton() {
        let vc = RequestListViewController()
        vc.title = "신청 목록"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchStudents() {
        manageStudentManager.getStudents { model in
            guard let model = model else { print("model을 불러오는 데에 실패했습니다."); return }
            if model.status == 200 {
                let students = model.sortedStudents
                self.students = students
            }
        }
    }
    
    @objc private func didTapLessonSongLabel(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let studentId = self.students[indexPath.row].id
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "추가", style: .default, handler: {  _ in
            
            
            let vc = SetLessonSongViewController()
            print("tapped, \(indexPath.row)")
            print("레슨곡 자리입니다! 학생 ID: \(studentId)")
            vc.modalPresentationStyle = .overFullScreen
            vc.studentId = studentId
            vc.isSettingMode = 1
            vc.setLessonSongCompletion = { () in
                self.manageStudentManager.getStudents { [weak self] model in
                    guard let model = model, let self = self else { return }
                    if model.status == 200 {
                        self.students = model.students
                        self.manageStudentView.tableView.reloadData()
                    }
                }
            }
            self.present(vc, animated: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
            
            let vc = SetLessonSongViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.isSettingMode = 0
            vc.studentId = studentId
            vc.setLessonSongCompletion = { () in
                self.manageStudentManager.getStudents { [weak self] model in
                    guard let model = model, let self = self else { return }
                    if model.status == 200 {
                        self.students = model.students
                        self.manageStudentView.tableView.reloadData()
                    }
                }
            }
            self.present(vc, animated: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.setLessonSongManager.deleteLessonSong(Int64(studentId)) { [weak self] model in
                print("\(studentId)번 학생 레슨곡 삭제 신청")
                guard let self = self, let model = model else { return }
                if model.status == 200 {
                    self.manageStudentManager.getStudents { [weak self] model in
                        guard let self = self, let model = model else { return }
                        if model.status == 200 {
                            self.students = model.students
                            self.manageStudentView.tableView.reloadData()
                        }
                    }
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
}

extension ManageStudentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentsTableViewCell.identifier, for: indexPath) as? StudentsTableViewCell else {
            print("StudentsTableViewCell 불러오기 실패")
            return UITableViewCell()
        }
        cell.configure(students[indexPath.row].name, target: self, #selector(didTapLessonSongLabel(_:)), indexPath, students[indexPath.row].singer, students[indexPath.row].songTitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 왼쪽에 만들기
        
        let write = UIContextualAction(style: .normal, title: "Write") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let vc = SelectModeViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.studentId = self.students[indexPath.row].id
            self.present(vc, animated: false)
            
            success(true)
        }
        write.image = UIImage(systemName: "pencil")
        write.backgroundColor = UIColor(hexCode: "747474")
        
        
        
        let chat = UIContextualAction(style: .normal, title: "Chat") { [weak self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            guard let self = self else { print("chat(Coach) - self is nil"); return }
            print("담당 학생과의 채팅 tap!")
            let vc = ChatViewController()
            let student = self.students[indexPath.row]
            vc.configureStudentId(Int64(student.id))
            vc.title = "\(student.name) 학생"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            success(true)
        }
        chat.image = UIImage(systemName: "ellipsis.bubble")
        chat.backgroundColor = UIColor(hexCode: "474747")
        
        //actions배열 인덱스 0이 왼쪽에 붙어서 나옴
        return UISwipeActionsConfiguration(actions:[write, chat])
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("담당 학생에서 삭제 tap!")
            self.manageStudentManager.deleteStudent(self.students[indexPath.row].id) { model in
                guard let model = model else { return }
                if model.status == 200 {
                    self.fetchStudents()
                    tableView.reloadData()
                }
                else {
                    let alert = UIAlertController(title: "", message: "삭제에 실패했습니다. 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
            success(true)
        }
        delete.image = UIImage(systemName: "minus.circle")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

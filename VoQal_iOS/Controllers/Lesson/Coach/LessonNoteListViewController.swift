//
//  LessonNoteListViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import UIKit

class LessonNoteListViewController: BaseViewController {

    private let lessonNoteListView = LessonNoteListView()
    private let lessonNoteListManager = LessonNoteListManager()
    
    private var studentId: Int? = nil
    private var lessonNoteList: [LessonNote] = []
    
    override func loadView() {
        view = lessonNoteListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lessonNoteListView.tableView.delegate = self
        lessonNoteListView.tableView.dataSource = self
        
        lessonNoteListView.tableView.register(LessonNoteListTableViewCell.self, forCellReuseIdentifier: LessonNoteListTableViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLessonNoteList()
    }
    
    override func setAddTarget() {
        lessonNoteListView.floatingButton.addTarget(self, action: #selector(didTapWriteLessonNoteBtn), for: .touchUpInside)
    }
    
    internal func setStudentId(studentId: Int) {
        self.studentId = studentId
    }
    
    private func fetchLessonNoteList() {
        guard let studentId = studentId else { print("fetchLessonNoteList - studentId is nil"); return }
        
        lessonNoteListManager.fetchLessonNoteList(studentId) { [weak self] model in
            guard let self = self, let model = model else { print("fetchLessonNoteList - model or self is nil"); return }
            
            if model.status == 200 {
                guard let data = model.data else { print("fetchLessonNoteList - model.data is nil"); return }
                lessonNoteList = data
                
                self.lessonNoteListView.tableView.reloadData()
            }
                
        }
    }

    @objc private func didTapWriteLessonNoteBtn() {
        print("writeLessonNote Tap!")
        
        let vc = WriteLessonNoteViewController()
        vc.studentId = self.studentId
        vc.delegate = self
        
        self.present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    
}

extension LessonNoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonNoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonNoteListTableViewCell.identifier, for: indexPath) as? LessonNoteListTableViewCell else {
            print("LessonNoteListTableViewCell dequeue failed!"); return UITableViewCell()
        }
        
        let lessonNote = lessonNoteList[indexPath.row]
        
        cell.configureCell(title: lessonNote.lessonNoteTitle, songTitle: lessonNote.songTitle, singer: lessonNote.singer, date: lessonNote.lessonDate)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            // 삭제 확인 알림창 표시
            let alert = UIAlertController(title: "레슨노트 삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completion(false)
            }
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let lessonNoteId = self.lessonNoteList[indexPath.row].lessonNoteId
                
                // API 호출하여 서버에서 삭제
                self.lessonNoteListManager.deleteLessonNote(Int64(lessonNoteId)) { [weak self] model in
                    guard let self = self, let model = model else { return }
                    
                    if model.status == 200 {
                        // 로컬 배열에서도 삭제
                        self.lessonNoteList.remove(at: indexPath.row)
                        
                        // 테이블뷰에서 애니메이션과 함께 셀 삭제
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                completion(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
        
        // 삭제 버튼 커스터마이징
        delete.image = UIImage(systemName: "trash.fill")  // SF Symbol 사용
        delete.backgroundColor = UIColor(hexCode: "FF3B30", alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension LessonNoteListViewController: WriteLessonNoteDelegate {
    func didFinishWritingLessonNote() {
        fetchLessonNoteList()
    }
}

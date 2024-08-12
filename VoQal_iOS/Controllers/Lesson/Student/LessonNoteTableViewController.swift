//
//  lessonNoteTableViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/2/24.
//

import UIKit

class LessonNoteTableViewController: UIViewController {

    private let lessonNoteTableView = LessonNoteTableView()
    private let lessonNoteManager = StudentLessonNoteManager()
    private var lessonNotes: [StudentLessonNote] = [] {
        didSet {
            self.lessonNoteTableView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = lessonNoteTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonNoteTableView.tableView.register(StudentLessonNoteTableViewCell.self, forCellReuseIdentifier: StudentLessonNoteTableViewCell.identifier)
        lessonNoteTableView.tableView.delegate = self
        lessonNoteTableView.tableView.dataSource = self

        fetchLessonNotes()
    }
    
    private func fetchLessonNotes() {
        lessonNoteManager.fetchLessonNotes { model in
            guard let model = model else { print("LessonNoteTableViewController_fetchLessonNotes: model 바인딩 실패"); return }
            if model.status == 200 {
                self.lessonNotes = model.sortedData
                print("레슨 일지 조회 성공")
            }
        }
    }
    
}

extension LessonNoteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentLessonNoteTableViewCell.identifier, for: indexPath) as? StudentLessonNoteTableViewCell
        else { print("LessonNoteTableViewController - cell dequeue 실패"); return UITableViewCell() }
        
        cell.configure(lessonNotes[indexPath.row].lessonNoteTitle, lessonNotes[indexPath.row].singer, lessonNotes[indexPath.row].songTitle, lessonNotes[indexPath.row].lessonDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LessonNoteDetailViewController()
        vc.setLessonNoteId(id: lessonNotes[indexPath.row].lessonNoteId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

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
    private var lessonNotes: [StudentLessonNote] = []
    
    override func loadView() {
        view = lessonNoteTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchLessonNotes()
    }
    
    private func fetchLessonNotes() {
        lessonNoteManager.fetchLessonNotes { model in
            guard let model = model else { print("LessonNoteTableViewController_fetchLessonNotes: model 바인딩 실패"); return }
            if model.status == 200 {
                self.lessonNotes = model.data
                print("레슨 일지 조회 성공")
            }
        }
    }
    
}

//extension LessonNoteTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

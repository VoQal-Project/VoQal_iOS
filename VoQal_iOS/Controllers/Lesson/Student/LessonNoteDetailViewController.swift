//
//  LessonNoteDetailViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/6/24.
//

import UIKit

class LessonNoteDetailViewController: BaseViewController {
    
    private let lessonNoteDetailView = LessonNoteDetailView()
    private let studentLessonNoteManager = StudentLessonNoteManager()
    private var lessonNoteId: Int? = nil

    override func loadView() {
        view = lessonNoteDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lessonNoteId = lessonNoteId {
            
            print(lessonNoteId)
            studentLessonNoteManager.getLessonNoteDetail(lessonNoteId) { model in
                guard let model = model else { print("LessonNoteDetailViewController - model 바인딩 실패"); return }
                
                if model.status == 200 {
                    self.lessonNoteDetailView.setupUI(title: model.data.lessonNoteTitle, artist: model.data.singer, songTitle: model.data.songTitle, content: model.data.contents, date: model.data.lessonDate)
                }
                
            }
        } else {
            print("LessonNoteDetailViewController - lessonNoteId가 nil입니다.")
        }
    }
    
    internal func setLessonNoteId(id: Int) {
        self.lessonNoteId = id
    }

}

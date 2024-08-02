//
//  StudentLessonManageViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/31/24.
//

import UIKit

class StudentLessonManageViewController: BaseViewController {

    private let studentLessonManagerView = StudentLessonManageView()
    private let lessonNoteTableViewController = LessonNoteTableViewController()
    private let recordFileTableViewController = RecordFileTableViewController()

    override func loadView() {
        view = studentLessonManagerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(studentLessonManagerView.lessonTabViewController)
        studentLessonManagerView.lessonTabViewController.didMove(toParent: self)
    }
    
    
    
    override func setAddTarget() {
        
    }

}


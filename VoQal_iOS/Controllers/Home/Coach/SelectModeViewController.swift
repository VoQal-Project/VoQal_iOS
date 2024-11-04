//
//  SelectModeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/29/24.
//

import UIKit
import UniformTypeIdentifiers

class SelectModeViewController: BaseViewController, UIDocumentPickerDelegate {
    
    private let selectModeView = SelectModeView()
    internal var recordFileURL: URL? = nil
    internal var studentId: Int?
    
    override func loadView() {
        view = selectModeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("selectModeVC - studentId is \(studentId)")
    }
    
    override func setAddTarget() {
        selectModeView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        selectModeView.uploadRecordFileButton.addTarget(self, action: #selector(didTapRecordFileListBtn), for: .touchUpInside)
        selectModeView.writeLessonNoteButton.addTarget(self, action: #selector(didTapLessonNoteListBtn), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapRecordFileListBtn() {
        let vc = RecordFileListViewController()
        
        guard let studentId = self.studentId else { print("didTapRecordFileListBtn - studentId is nil"); return }
        vc.setStudentId(studentId: studentId)
        vc.title = "녹음 파일"
        print("didTapRecordFileListBtn")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLessonNoteListBtn() {
        let vc = LessonNoteListViewController()
        
        guard let studentId = self.studentId else { print("didTapLessonNoteListBtn - studentId is nil"); return }
        vc.setStudentId(studentId: studentId)
        vc.title = "수업 일지"
        print("didTapLessonNoteListBtn")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

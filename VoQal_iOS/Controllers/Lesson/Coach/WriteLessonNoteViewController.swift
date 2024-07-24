//
//  WriteLessonNoteViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import UIKit

class WriteLessonNoteViewController: BaseViewController {
    
    private let writeLessonNoteView = WriteLessonNoteView()
    private let writeLessonNoteViewManager = WriteLessonNoteManager()

    override func loadView() {
        view = writeLessonNoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writeLessonNoteView.contentViewTextView.delegate = self
    }
    
    override func setupNavigationBar() {
        let postButton = UIBarButtonItem(title: "게시", style: .done, target: self, action: #selector(postLessonNote))
        
        self.navigationItem.rightBarButtonItem = postButton
    }
    
    override func setAddTarget() {
        writeLessonNoteView.uploadButton.addTarget(self, action: #selector(uploadRecordFile), for: .touchUpInside)
    }
    
    @objc private func postLessonNote() {
        
        
        
    }
    
    @objc private func uploadRecordFile() {
        print("uploadRecordFile tap!")
    }

    
}

extension WriteLessonNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = UIColor(named: "placeholderColor")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        writeLessonNoteView.textCountLabel.text = "\(changedText.count)/600자"
        
        return changedText.count <= 600
    }
}

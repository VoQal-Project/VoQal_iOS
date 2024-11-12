//
//  WriteLessonNoteViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import UIKit
import UniformTypeIdentifiers

protocol WriteLessonNoteDelegate: AnyObject {
    func didFinishWritingLessonNote()
}

class WriteLessonNoteViewController: BaseViewController, UIDocumentPickerDelegate {
    
    private var postBarButton: UIBarButtonItem?
    
    private let writeLessonNoteView = WriteLessonNoteView()
    private let writeLessonNoteManager = WriteLessonNoteManager()
    
    internal var studentId: Int? = nil
    weak var delegate: WriteLessonNoteDelegate? = nil
    
    override func loadView() {
        view = writeLessonNoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setAddTarget()
        writeLessonNoteView.contentViewTextView.delegate = self
    }
    
    override func setupNavigationBar() {
        postBarButton = UIBarButtonItem(title: "게시", style: .done, target: self, action: #selector(postButtonTapped))
        
        self.navigationItem.rightBarButtonItem = postBarButton
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.white), style: .done, target: self, action: #selector(didTapBackButton))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func postButtonTapped() {
        postBarButton?.throttle(seconds: 3.0, action: { [weak self] in
            self?.postLessonNote()
        })
    }
    
    @objc private func postLessonNote() {
        print("게시!")
        let lessonDate = DateUtility.convertSelectedDate(writeLessonNoteView.datePicker.date, true)
        guard let lessonNoteTitle = writeLessonNoteView.titleTextField.text,
              let artist = writeLessonNoteView.artistTextField.text,
              let songTitle = writeLessonNoteView.songTitleTextField!.text,
              let content = writeLessonNoteView.contentViewTextView.text,
              let studentId = self.studentId else {
            
            let alert = UIAlertController(title: "게시 실패!", message: "모든 필드가 채워져야 게시할 수 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true); return
        }
        
        if validateAllFields(lessonNoteTitle, artist, songTitle, content) {
            print(validateAllFields(lessonNoteTitle, artist, songTitle, content))
            let alert = UIAlertController(title: "이대로 게시할까요?", message: "현재 작성하신 내용 그대로 수업 일지와 녹음 파일을 게시합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.writeLessonNoteManager.writeLessonNote(studentId, songTitle, lessonNoteTitle, content, artist, lessonDate) { model in
                    guard let model = model else { print("postLessonNote - model 바인딩 실패"); return }
                    
                    if model.status == 200 {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                            self.delegate?.didFinishWritingLessonNote()
                            self.dismiss(animated: true)
                        }
                    }
                    else {
                        let alert = UIAlertController(title: "게시 실패!", message: "게시에 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true)

            print("게시 api 전 테스트")
            
        }
        
    }
    
    private func validateAllFields(_ lessonNoteTitle: String?, _ artist: String?, _ songTitle: String?, _ content: String?) -> Bool {
        var errorComponents = [String]()
        
        print(lessonNoteTitle)
        print(artist)
        print(songTitle)
        print(content)
        
        if lessonNoteTitle == "" { errorComponents.append("레슨 일지 제목") }
        if artist == "" { errorComponents.append("가수명") }
        if songTitle == "" { errorComponents.append("곡명") }
        if content == "" || content == "내용을 입력해주세요." { errorComponents.append("본문") }
        
        if errorComponents.isEmpty {
            print("모든 필드에 값이 있습니다.")
            return true
        }
        else {
            let message = "다음 항목들을 확인해주세요:\n\(errorComponents.joined(separator: ", "))\n모든 필드에 내용을 입력해 주세요."
            let alert = UIAlertController(title: "게시 실패!", message: "\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return false
        }
        
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

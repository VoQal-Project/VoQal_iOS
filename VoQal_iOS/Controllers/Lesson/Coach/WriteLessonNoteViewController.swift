//
//  WriteLessonNoteViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class WriteLessonNoteViewController: BaseViewController, UIDocumentPickerDelegate {
    
    private let writeLessonNoteView = WriteLessonNoteView()
    private let writeLessonNoteManager = WriteLessonNoteManager()
    internal var recordFileURL: URL? = nil
    internal var studentId: Int? = nil
    
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
        let postButton = UIBarButtonItem(title: "게시", style: .done, target: self, action: #selector(postLessonNote))
        
        self.navigationItem.rightBarButtonItem = postButton
    }
    
    override func setAddTarget() {
        writeLessonNoteView.uploadButton.addTarget(self, action: #selector(uploadRecordFile), for: .touchUpInside)
    }
    
    @objc private func postLessonNote() {
        print("게시!")
        let lessonDate = DateUtility.convertSelectedDate(writeLessonNoteView.datePicker.date, true)
        guard let lessonNoteTitle = writeLessonNoteView.titleTextField.text,
              let artist = writeLessonNoteView.artistTextField.text,
              let songTitle = writeLessonNoteView.songTitleTextField!.text,
              let content = writeLessonNoteView.contentViewTextView.text,
              let fileUrl = self.recordFileURL,
              let recordTitle = writeLessonNoteView.recordTitleLabel.text,
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
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5){
                            self.writeLessonNoteManager.uploadRecordFile(studentId: studentId, recordDate: lessonDate, recordTitle: recordTitle, fileURL: fileUrl) { model in
                                guard let model = model else { print("uploadRecordFile - model 바인딩 실패"); return }
                                if model.status == 200 {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else {
                                    let alert = UIAlertController(title: "게시 실패!", message: "게시에 실패했습니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                }
                            }
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
    
    @objc private func uploadRecordFile() {
        print("uploadRecordFile tap!")
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        // UploadRecordViewController로 전환
        let uploadRecordVC = UploadRecordViewController(selectedFileURL: selectedFileURL)
        uploadRecordVC.modalPresentationStyle = .overFullScreen
        uploadRecordVC.uploadRecordCompletion = { (url: URL, title: String) in
            self.recordFileURL = url
            self.writeLessonNoteView.recordTextField.text = title
            self.writeLessonNoteView.recordTitleLabel.text = url.lastPathComponent
            let configuration = UIImage.SymbolConfiguration(pointSize: 15)
            self.writeLessonNoteView.recordIcon.image = UIImage(systemName: "music.note", withConfiguration: configuration)
        }
        present(uploadRecordVC, animated: true)
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
            let message = "다음 항목들을 확인해주세요: \(errorComponents.joined(separator: ", "))\n모든 필드에 내용을 입력해 주세요."
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

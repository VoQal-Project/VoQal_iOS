//
//  EditLessonNoteViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/12/24.
//

import UIKit

protocol EditLessonNoteDelegate: AnyObject {
    func didFinishEditLessonNote()
}

class EditLessonNoteViewController: BaseViewController {
    
    private let editLessonNoteView = EditLessonNoteView()
    private let editLessonNoteManager = EditLessonNoteManager()
    
    var lessonNoteId: Int64? = nil
    
    weak var delegate: EditLessonNoteDelegate?
    
    override func loadView() {
        view = editLessonNoteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureFields()
    }
    
    override func setupNavigationBar() {
        let postButton = UIBarButtonItem(title: "게시", style: .done, target: self, action: #selector(editLessonNote))
        
        self.navigationItem.rightBarButtonItem = postButton
    }
    
    private func configureFields() {
        guard let lessonNoteId = self.lessonNoteId else { print("configureFields - lessonNoteId is nil"); return }
        
        editLessonNoteManager.fetchLessonNote(lessonNoteId) { [weak self] model in
            guard let self = self, let model = model else { print("configureFields - model or self is nil"); return }
            
            if model.status == 200 {
                guard let songTitleTextField = editLessonNoteView.songTitleTextField else { print("configureFields - songTitleTextField is nil"); return }
                
                self.editLessonNoteView.titleTextField.text = model.data.lessonNoteTitle
                songTitleTextField.text = model.data.songTitle
                self.editLessonNoteView.artistTextField.text = model.data.singer
                self.editLessonNoteView.datePicker.date = DateUtility.convertStringToDate(model.data.lessonDate)
                self.editLessonNoteView.contentViewTextView.text = model.data.contents
                self.editLessonNoteView.contentViewTextView.textColor = .white
            }
        }
        
    }
    
    @objc private func editLessonNote() {
        
        print("게시!")
        let lessonDate = DateUtility.convertSelectedDate(editLessonNoteView.datePicker.date, true)
        guard let lessonNoteTitle = editLessonNoteView.titleTextField.text,
              let artist = editLessonNoteView.artistTextField.text,
              let songTitle = editLessonNoteView.songTitleTextField!.text,
              let lessonNoteId = self.lessonNoteId,
              let content = editLessonNoteView.contentViewTextView.text else {
            
            let alert = UIAlertController(title: "수정 실패!", message: "모든 필드가 채워져야 게시할 수 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true); return
        }
        
        if validateAllFields(lessonNoteTitle, artist, songTitle, content) {
            print(validateAllFields(lessonNoteTitle, artist, songTitle, content))
            let alert = UIAlertController(title: "이대로 수정할까요?", message: "현재 작성하신 내용 그대로 수업 일지를 수정합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.editLessonNoteManager.editLessonNote(title: lessonNoteTitle, songTitle: songTitle, contents: content, singer: artist, lessonDate: lessonDate, lessonNoteId: lessonNoteId) { model in
                    guard let model = model else { print("postLessonNote - model 바인딩 실패"); return }
                    
                    if model.status == 200 {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                            self.delegate?.didFinishEditLessonNote()
                            self.navigationController?.popViewController(animated: true)
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

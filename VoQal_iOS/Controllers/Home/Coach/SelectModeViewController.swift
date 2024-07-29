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
        
        
    }
    
    override func setAddTarget() {
        selectModeView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        selectModeView.uploadRecordFileButton.addTarget(self, action: #selector(didTapUploadRecordFileBtn), for: .touchUpInside)
        selectModeView.writeLessonNoteButton.addTarget(self, action: #selector(didTapWriteLessonNoteBtn), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapWriteLessonNoteBtn() {
        print("writeLessonNote Tap!")
        
        let vc = WriteLessonNoteViewController()
        vc.studentId = self.studentId
        
        self.present(UINavigationController(rootViewController: vc), animated: true)
        
    }
    
    @objc private func didTapUploadRecordFileBtn() {
        print("uploadRecordFile Tap!")
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        // 선택된 파일 경로 확인
        print("Selected File URL: \(selectedFileURL)")
        
        // 보안 범위 시작
        guard selectedFileURL.startAccessingSecurityScopedResource() else {
            print("파일에 접근할 수 없습니다.")
            return
        }
        
        defer {
            // 보안 범위 종료
            selectedFileURL.stopAccessingSecurityScopedResource()
        }
        
        // 파일을 앱의 Documents 디렉토리로 복사
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        do {
            // 기존 파일이 있다면 삭제
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            // 파일 복사
            try fileManager.copyItem(at: selectedFileURL, to: destinationURL)
            self.recordFileURL = destinationURL
            
            // UploadRecordViewController로 전환
            let uploadRecordVC = UploadRecordViewController(selectedFileURL: destinationURL)
            uploadRecordVC.studentId = self.studentId
            uploadRecordVC.modalPresentationStyle = .overFullScreen
            present(uploadRecordVC, animated: true)
            
        } catch {
            print("파일 복사 중 오류 발생: \(error)")
        }
    }
}
